import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:boxing/features/ads/presentation/ads_controller.dart';

/// Displays an adaptive banner ad anchored at the bottom of its parent.
///
/// Returns [SizedBox.shrink] when:
/// - The user is ad-free (purchased ad removal).
/// - The ad has not finished loading yet.
/// - The ad failed to load.
class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    if (ref.read(isAdFreeProvider)) return;
    if (_bannerAd != null) return; // already loading / loaded

    final adService = ref.read(adServiceProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    adService.onBannerLoaded = (ad) {
      if (mounted) {
        setState(() {
          _bannerAd = ad;
          _isLoaded = true;
        });
      }
    };

    await adService.loadBannerAd(screenWidth);

    // If already loaded synchronously (cached), pick it up
    final existing = adService.bannerAd;
    if (existing != null && mounted) {
      setState(() {
        _bannerAd = existing;
        _isLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    // Banner lifecycle is managed by AdService; don't dispose here.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdFree = ref.watch(isAdFreeProvider);
    if (isAdFree || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
