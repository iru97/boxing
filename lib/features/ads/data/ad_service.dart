import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:boxing/features/ads/data/ad_config.dart';

/// Manages banner and interstitial ad lifecycle.
///
/// All ad operations check [_isAdFreeCheck] first and no-op if the user has
/// purchased ad removal. Ad load failures are caught and logged -- the app
/// must never crash over a failed ad.
class AdService {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerLoaded = false;
  bool _isInterstitialLoaded = false;
  DateTime? _lastInterstitialShown;
  bool Function() _isAdFreeCheck = () => false;

  static const _interstitialCooldown = Duration(minutes: 3);

  /// Provide a callback that returns `true` when the user is ad-free.
  void setAdFreeCheck(bool Function() check) {
    _isAdFreeCheck = check;
  }

  /// Initialize the Mobile Ads SDK. Call once at app startup.
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // --------------- Banner ---------------

  /// Load an adaptive banner ad sized to [screenWidth].
  Future<void> loadBannerAd(double screenWidth) async {
    if (_isAdFreeCheck()) return;

    final adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      screenWidth.truncate(),
    );
    if (adSize == null) return;

    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerLoaded = true;
          _onBannerLoaded?.call(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          _isBannerLoaded = false;
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  /// Callback invoked when a banner finishes loading.
  void Function(BannerAd)? _onBannerLoaded;
  set onBannerLoaded(void Function(BannerAd)? callback) =>
      _onBannerLoaded = callback;

  /// Currently loaded banner, or `null` if unavailable.
  BannerAd? get bannerAd => _isBannerLoaded ? _bannerAd : null;

  /// Whether a banner is currently loaded and ready to display.
  bool get isBannerLoaded => _isBannerLoaded;

  /// Dispose only the banner ad (e.g. when leaving the home screen).
  void disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerLoaded = false;
  }

  // --------------- Interstitial ---------------

  /// Pre-load an interstitial so it is ready when needed.
  Future<void> preloadInterstitial() async {
    if (_isAdFreeCheck()) return;
    if (_isInterstitialLoaded) return;

    await InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _isInterstitialLoaded = false;
        },
      ),
    );
  }

  /// Show the interstitial if loaded and cooldown has elapsed.
  ///
  /// Returns `true` if the ad was actually shown.
  Future<bool> showInterstitialIfReady() async {
    if (_isAdFreeCheck()) return false;
    if (!_isInterstitialLoaded || _interstitialAd == null) return false;

    // Enforce cooldown
    if (_lastInterstitialShown != null) {
      final elapsed = DateTime.now().difference(_lastInterstitialShown!);
      if (elapsed < _interstitialCooldown) return false;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialLoaded = false;
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialLoaded = false;
        preloadInterstitial();
      },
    );

    await _interstitialAd!.show();
    _lastInterstitialShown = DateTime.now();
    return true;
  }

  // --------------- Cleanup ---------------

  /// Dispose all loaded ads.
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _bannerAd = null;
    _interstitialAd = null;
    _isBannerLoaded = false;
    _isInterstitialLoaded = false;
  }
}
