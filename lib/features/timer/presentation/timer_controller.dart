import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/features/audio/data/audio_player_service.dart';
import 'package:boxing/features/audio/data/voice_service.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/timer/domain/timer_engine.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';

/// Provides the singleton BoxingAudioService (overridden in main.dart).
final audioServiceProvider = Provider<BoxingAudioService>((ref) {
  throw UnimplementedError('audioServiceProvider must be overridden in main.dart');
});

/// Provides the singleton VoiceService (overridden in main.dart).
final voiceServiceProvider = Provider<VoiceService>((ref) {
  throw UnimplementedError('voiceServiceProvider must be overridden in main.dart');
});

/// Provides the TimerEngine with audio cue + voice announcement integration.
final timerEngineProvider = Provider<TimerEngine>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  final voiceService = ref.watch(voiceServiceProvider);
  final engine = TimerEngine(
    onAudioCue: (cue) => audioService.playCue(cue),
    onVoiceAnnounce: (event) async {
      // Wait for the bell to ring before speaking
      await Future.delayed(const Duration(milliseconds: 500));
      voiceService.announce(event);
    },
  );
  ref.onDispose(() => engine.dispose());
  return engine;
});

/// Stream of timer state updates.
final timerStateProvider = StreamProvider<TimerState>((ref) {
  final engine = ref.watch(timerEngineProvider);
  return engine.stateStream;
});

/// The currently active session being timed.
final activeSessionProvider = StateProvider<SessionModel?>((ref) => null);

/// Whether the timer is actively running (not idle, not completed).
final isTimerRunningProvider = Provider<bool>((ref) {
  final engine = ref.watch(timerEngineProvider);
  return engine.isRunning;
});
