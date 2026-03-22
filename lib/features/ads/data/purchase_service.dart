import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:boxing/features/ads/data/ad_config.dart';

/// Manages the "Remove Ads" non-consumable in-app purchase.
///
/// Responsible only for product querying and initiating purchase/restore flows.
/// The IAP purchase stream is handled exclusively by [EntitlementService] to
/// avoid double-completion and state divergence (audit items C1, C2).
class PurchaseService {
  ProductDetails? _removeAdsProduct;

  /// The store product details, or `null` if not yet queried or unavailable.
  ProductDetails? get removeAdsProduct => _removeAdsProduct;

  /// Query product details from the store. Call once at app startup.
  Future<void> initialize() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) return;

    final response = await InAppPurchase.instance.queryProductDetails(
      {AdConfig.removeAdsProductId},
    );
    if (response.productDetails.isNotEmpty) {
      _removeAdsProduct = response.productDetails.first;
    }
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('PurchaseService: products not found: ${response.notFoundIDs}');
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
}
