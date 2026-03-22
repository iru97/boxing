import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:boxing/app/app.dart';
import 'package:boxing/core/constants/app_constants.dart';
import 'package:boxing/features/ads/data/ad_service.dart';
import 'package:boxing/features/ads/data/purchase_service.dart';
import 'package:boxing/features/ads/presentation/ads_controller.dart';
import 'package:boxing/features/audio/data/audio_player_service.dart';
import 'package:boxing/features/audio/data/voice_service.dart';
import 'package:boxing/features/entitlements/data/entitlement_service.dart';
import 'package:boxing/features/entitlements/presentation/entitlement_provider.dart';
import 'package:boxing/features/history/presentation/history_controller.dart';
import 'package:boxing/features/sessions/presentation/template_controller.dart';
import 'package:boxing/features/timer/presentation/checkpoint_controller.dart';
import 'package:boxing/features/timer/presentation/timer_controller.dart';
import 'package:boxing/features/programs/presentation/programs_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fonts are bundled in assets/fonts/ — never fetch from network.
  // The google_fonts package auto-detects local files by filename.
  GoogleFonts.config.allowRuntimeFetching = false;

  await Hive.initFlutter();
  final sessionsBox =
      await Hive.openBox<String>(AppConstants.sessionsBoxName);
  final settingsBox =
      await Hive.openBox<String>(AppConstants.settingsBoxName);
  final templatesBox =
      await Hive.openBox<String>(AppConstants.templatesBoxName);
  final historyBox =
      await Hive.openBox<String>(AppConstants.historyBoxName);
  final checkpointBox =
      await Hive.openBox<String>(AppConstants.checkpointBoxName);
  final programProgressBox =
      await Hive.openBox<String>(AppConstants.programProgressBoxName);

  // Initialize audio service for background playback
  final audioService = BoxingAudioService();
  await audioService.initWithHandler();

  // Initialize voice announcement service
  final voiceService = VoiceService();
  await voiceService.init();

  // Initialize Mobile Ads SDK
  final adService = AdService();
  await adService.initialize();

  // Initialize in-app purchase service
  final purchaseService = PurchaseService(settingsBox);
  await purchaseService.initialize();

  // Initialize entitlement service (premium feature access)
  final entitlementService = EntitlementService(settingsBox);
  await entitlementService.initialize();

  // Wire ad-free check so ads are suppressed for purchasers
  adService.setAdFreeCheck(() => purchaseService.isAdFree);

  // Pre-load interstitial so it is ready for the first natural break
  await adService.preloadInterstitial();

  // Request ATT permission on iOS (improves ad revenue via personalization)
  if (Platform.isIOS) {
    final status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(seconds: 1));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  // Use UncontrolledProviderScope so EntitlementService can push updates
  // into the provider container via callback.
  final container = ProviderContainer(overrides: [
    sessionsBoxProvider.overrideWithValue(sessionsBox),
    settingsBoxProvider.overrideWithValue(settingsBox),
    templateBoxProvider.overrideWithValue(templatesBox),
    historyBoxProvider.overrideWithValue(historyBox),
    checkpointBoxProvider.overrideWithValue(checkpointBox),
    programProgressBoxProvider.overrideWithValue(programProgressBox),
    audioServiceProvider.overrideWithValue(audioService),
    voiceServiceProvider.overrideWithValue(voiceService),
    adServiceProvider.overrideWithValue(adService),
    purchaseServiceProvider.overrideWithValue(purchaseService),
    isAdFreeProvider.overrideWith((ref) => purchaseService.isAdFree),
    entitlementServiceProvider.overrideWithValue(entitlementService),
  ]);

  // Wire entitlement status updates into Riverpod
  entitlementService.onStatusChanged = () {
    container.read(entitlementStatusProvider.notifier).state =
        entitlementService.status;
  };
  container.read(entitlementStatusProvider.notifier).state =
      entitlementService.status;

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BoxingApp(),
    ),
  );
}

/// Hive box providers for dependency injection
final sessionsBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('sessionsBoxProvider must be overridden');
});

final settingsBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('settingsBoxProvider must be overridden');
});
