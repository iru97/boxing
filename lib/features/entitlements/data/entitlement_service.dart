import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:boxing/features/entitlements/domain/entitlement_status.dart';
import 'package:boxing/features/entitlements/data/entitlement_config.dart';

/// Manages entitlement state from IAP purchases.
///
/// Reads from Hive cache on init for instant UI access.
/// Listens to the IAP purchase stream for live updates.
/// Store is the source of truth — cache is optimistic.
///
/// This is the **sole** listener of [InAppPurchase.purchaseStream] to prevent
/// double-completion of purchases (audit item C1).
class EntitlementService {
  final Box<String> _box;
  static const _cacheKey = 'entitlement_status';

  EntitlementStatus _status = EntitlementStatus.empty;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  /// Callback invoked when entitlement status changes.
  /// Used by Riverpod provider to update reactive state.
  VoidCallback? onStatusChanged;

  EntitlementService(this._box);

  /// Current entitlement status.
  EntitlementStatus get status => _status;

  /// Initialize from Hive cache and start listening to purchases.
  Future<void> initialize() async {
    // Load from cache
    final cached = _box.get(_cacheKey);
    if (cached != null) {
      try {
        final json = Map<String, dynamic>.from(
          const JsonDecoder().convert(cached) as Map,
        );
        _status = EntitlementStatus.fromJson(json);
      } catch (e) {
        debugPrint('EntitlementService: cache parse error: $e');
      }
    }

    // Listen to purchase stream (only if store is available)
    final iap = InAppPurchase.instance;
    final available = await iap.isAvailable();
    if (!available) return;

    _purchaseSubscription = iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) {
        debugPrint('EntitlementService: purchase stream error: $error');
      },
    );
  }

  /// Trigger store restore flow (required by Apple).
  Future<void> restorePurchases() async {
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      debugPrint('EntitlementService: restorePurchases failed: $e');
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _status = EntitlementConfig.applyPurchase(
          _status,
          purchase.productID,
        );
        _saveCache();
        onStatusChanged?.call();
      }
      // Must complete ALL terminal statuses to clear the purchase queue
      if (purchase.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

  void _saveCache() {
    try {
      final json = const JsonEncoder().convert(_status.toJson());
      _box.put(_cacheKey, json);
    } catch (e) {
      debugPrint('EntitlementService: cache save error: $e');
    }
  }

  void dispose() {
    _purchaseSubscription?.cancel();
  }
}
