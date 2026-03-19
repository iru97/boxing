import 'dart:io';

/// Centralized ad configuration: unit IDs, test/production toggle, IAP product ID.
///
/// During development, [testMode] must be `true` to use Google-provided test ad
/// unit IDs. Set to `false` and replace the production IDs before release.
class AdConfig {
  AdConfig._();

  /// Set to `false` for production builds.
  static const bool testMode = true;

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

  /// IAP product ID -- must match store configuration exactly.
  static const String removeAdsProductId = 'remove_ads';
}
