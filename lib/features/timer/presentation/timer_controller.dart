import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/features/audio/data/audio_player_service.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/timer/domain/timer_engine.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';

/// Provides the singleton BoxingAudioService.
final audioServiceProvider = Provider<BoxingAudioService>((ref) {
  final service = BoxingAudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provides the TimerEngine with audio cue integration.
final timerEngineProvider = Provider<TimerEngine>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  final engine = TimerEngine(
    onAudioCue: (cue) => audioService.playCue(cue),
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
