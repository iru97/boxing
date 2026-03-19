import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:boxing/features/ads/data/ad_service.dart';
import 'package:boxing/features/ads/data/purchase_service.dart';

/// Provides the [AdService] singleton, initialized and overridden in main.dart.
final adServiceProvider = Provider<AdService>((ref) {
  throw UnimplementedError('adServiceProvider must be overridden');
});

/// Provides the [PurchaseService] singleton, initialized and overridden in main.dart.
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  throw UnimplementedError('purchaseServiceProvider must be overridden');
});

/// Whether the user has purchased ad removal. Drives conditional ad display.
final isAdFreeProvider = StateProvider<bool>((ref) => false);

/// The currently loaded banner ad, or null.
final bannerAdProvider = StateProvider<BannerAd?>((ref) => null);
