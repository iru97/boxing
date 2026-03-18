import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:boxing/app/app.dart';
import 'package:boxing/core/constants/app_constants.dart';
import 'package:boxing/features/audio/data/audio_player_service.dart';
import 'package:boxing/features/audio/data/voice_service.dart';
import 'package:boxing/features/history/presentation/history_controller.dart';
import 'package:boxing/features/sessions/presentation/template_controller.dart';
import 'package:boxing/features/timer/presentation/checkpoint_controller.dart';
import 'package:boxing/features/timer/presentation/timer_controller.dart';

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

  // Initialize audio service for background playback
  final audioService = BoxingAudioService();
  await audioService.initWithHandler();

  // Initialize voice announcement service
  final voiceService = VoiceService();
  await voiceService.init();

  runApp(
    ProviderScope(
      overrides: [
        sessionsBoxProvider.overrideWithValue(sessionsBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
        templateBoxProvider.overrideWithValue(templatesBox),
        historyBoxProvider.overrideWithValue(historyBox),
        checkpointBoxProvider.overrideWithValue(checkpointBox),
        audioServiceProvider.overrideWithValue(audioService),
        voiceServiceProvider.overrideWithValue(voiceService),
      ],
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
