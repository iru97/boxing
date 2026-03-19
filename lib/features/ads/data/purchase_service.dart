import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:boxing/features/ads/data/ad_config.dart';

/// Manages the "Remove Ads" non-consumable in-app purchase.
///
/// On initialization the cached ad-free flag is read from Hive for instant UI
/// response, then the purchase stream is subscribed for real-time updates.
class PurchaseService {
  final Box<String> _settingsBox;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAdFree = false;
  ProductDetails? _removeAdsProduct;

  static const _adFreeKey = 'is_ad_free';

  PurchaseService(this._settingsBox);

  /// Whether the user has purchased ad removal.
  bool get isAdFree => _isAdFree;

  /// The store product details, or `null` if not yet queried or unavailable.
  ProductDetails? get removeAdsProduct => _removeAdsProduct;

  /// Called when purchase status changes. Allows the controller to refresh UI.
  VoidCallback? onPurchaseStatusChanged;

  /// Initialize: check cache, subscribe to purchase stream, query product.
  Future<void> initialize() async {
    // Instant UI response from cache
    _isAdFree = _settingsBox.get(_adFreeKey) == 'true';

    final available = await InAppPurchase.instance.isAvailable();
    if (!available) return;

    // Listen to purchase updates
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) {
        debugPrint('Purchase stream error: $error');
      },
    );

    // Query product details
    final response = await InAppPurchase.instance.queryProductDetails(
      {AdConfig.removeAdsProductId},
    );
    if (response.productDetails.isNotEmpty) {
      _removeAdsProduct = response.productDetails.first;
    }
  }

  /// Start the purchase flow for ad removal.
  Future<bool> purchaseRemoveAds() async {
    if (_removeAdsProduct == null) return false;
    final purchaseParam = PurchaseParam(
      productDetails: _removeAdsProduct!,
    );
    return InAppPurchase.instance.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  /// Restore previous purchases (required by Apple).
  Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final details in purchaseDetailsList) {
      if (details.productID != AdConfig.removeAdsProductId) continue;

      switch (details.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _setAdFree(true);
          if (details.pendingCompletePurchase) {
            InAppPurchase.instance.completePurchase(details);
          }
          break;
        case PurchaseStatus.error:
          debugPrint('Purchase error: ${details.error}');
          break;
        case PurchaseStatus.pending:
        case PurchaseStatus.canceled:
          break;
      }
    }
  }

  void _setAdFree(bool value) {
    _isAdFree = value;
    _settingsBox.put(_adFreeKey, value.toString());
    onPurchaseStatusChanged?.call();
  }

  /// Cancel the purchase stream subscription.
  void dispose() {
    _subscription?.cancel();
  }
}
