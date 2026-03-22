import 'dart:io';

import 'package:flutter/foundation.dart';

/// Centralized ad configuration: unit IDs, test/production toggle, IAP product ID.
///
/// [testMode] follows [kDebugMode]: `true` in debug builds (test ads),
/// `false` in release builds (production ads). Override per-run with
/// `--dart-define=AD_TEST_MODE=true` if needed.
class AdConfig {
  AdConfig._();

  /// Automatically true in debug, false in release.
  static const bool testMode = kDebugMode;

  // --- Test Ad Unit IDs (Google-provided, safe for development) ---
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIos =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIos =
      'ca-app-pub-3940256099942544/4411468910';

  // --- Production Ad Unit IDs (replace before release) ---
  static const String _prodBannerAndroid = 'YOUR_BANNER_ANDROID_ID';
  static const String _prodBannerIos = 'YOUR_BANNER_IOS_ID';
  static const String _prodInterstitialAndroid =
      'YOUR_INTERSTITIAL_ANDROID_ID';
  static const String _prodInterstitialIos = 'YOUR_INTERSTITIAL_IOS_ID';

  static String get bannerAdUnitId {
    if (testMode) {
      return Platform.isAndroid ? _testBannerAndroid : _testBannerIos;
    }
    return Platform.isAndroid ? _prodBannerAndroid : _prodBannerIos;
  }

  static String get interstitialAdUnitId {
    if (testMode) {
      return Platform.isAndroid
          ? _testInterstitialAndroid
          : _testInterstitialIos;
    }
    return Platform.isAndroid
        ? _prodInterstitialAndroid
        : _prodInterstitialIos;
  }

  /// Debug-mode check: warns if production ad IDs haven't been configured.
  /// Call from main.dart during app initialization to catch placeholder IDs
  /// before they slip into a release build.
  static void validateAdIds() {
    assert(() {
      if (_prodBannerAndroid.startsWith('YOUR_') ||
          _prodBannerIos.startsWith('YOUR_') ||
          _prodInterstitialAndroid.startsWith('YOUR_') ||
          _prodInterstitialIos.startsWith('YOUR_')) {
        debugPrint('WARNING: Ad unit IDs are still placeholders. '
            'Replace with real IDs before release.');
      }
      return true;
    }());
  }

  /// IAP product ID -- must match store configuration exactly.
  static const String removeAdsProductId = 'remove_ads';
}
