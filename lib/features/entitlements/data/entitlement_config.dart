import 'package:boxing/features/entitlements/domain/entitlement_status.dart';

/// Maps store product IDs to entitlement status field mutations.
class EntitlementConfig {
  EntitlementConfig._();

  static const String removeAds = 'remove_ads';
  static const String comboPack = 'combo_callouts_pack';
  static const String programsPack = 'programs_pack'; // future
  static const String everythingBundle = 'everything_bundle'; // future

  /// Product IDs to query from the store on launch.
  /// Only includes currently-sold products. Future products (programsPack,
  /// everythingBundle) will be added here when they go on sale.
  static const Set<String> allProductIds = {
    removeAds,
    comboPack,
  };

  /// Apply a purchase to the current entitlement status.
  static EntitlementStatus applyPurchase(
    EntitlementStatus current,
    String productId,
  ) {
    // Handle sport pack pattern
    if (productId.startsWith('sport_pack_')) {
      final sportId = productId.replaceFirst('sport_pack_', '');
      return current.copyWith(
        sportPacks: {...current.sportPacks, sportId: true},
      );
    }

    return switch (productId) {
      removeAds => current.copyWith(adsRemoved: true),
      comboPack => current.copyWith(comboPack: true),
      programsPack => current.copyWith(programsPack: true),
      everythingBundle => current.copyWith(
        adsRemoved: true,
        comboPack: true,
        programsPack: true,
        everythingBundle: true,
      ),
      _ => current, // Unknown product — no change
    };
  }
}
