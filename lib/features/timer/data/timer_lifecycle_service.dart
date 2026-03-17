import 'package:flutter/widgets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:boxing/features/audio/data/audio_player_service.dart';
import 'package:boxing/features/timer/domain/timer_engine.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';

/// Manages lifecycle events, wake lock, and notification updates
/// for the timer during active sessions.
class TimerLifecycleService with WidgetsBindingObserver {
  final TimerEngine engine;
  final BoxingAudioService audioService;

  bool _wakeLockEnabled = false;
  DateTime? _lastNotificationUpdate;

  TimerLifecycleService({
    required this.engine,
    required this.audioService,
  });

  /// Call when a session starts.
  Future<void> onSessionStart() async {
    WidgetsBinding.instance.addObserver(this);
    await _enableWakeLock();
    await audioService.startKeepAlive();

    // Listen to timer state for notification updates
    engine.stateStream.listen(_onTimerStateUpdate);
  }

  /// Call when a session ends or is stopped.
  Future<void> onSessionEnd() async {
    WidgetsBinding.instance.removeObserver(this);
    await _disableWakeLock();
    await audioService.stopKeepAlive();
    audioService.clearNotification();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // App going to background — silent audio keeps us alive
        break;
      case AppLifecycleState.resumed:
        // App returning to foreground — timer auto-resyncs via DateTime
        break;
      case AppLifecycleState.inactive:
        // System dialog or phone call
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onTimerStateUpdate(TimerState state) {
    // Throttle notification updates to once per second
    final now = DateTime.now();
    if (_lastNotificationUpdate != null &&
        now.difference(_lastNotificationUpdate!) <
            const Duration(seconds: 1)) {
      return;
    }
    _lastNotificationUpdate = now;

    final phaseLabel = switch (state.phase) {
      TimerWarmup() => 'WARMUP',
      TimerWork(:final isWarning) => isWarning ? 'WARNING' : 'WORK',
      TimerRest() => 'REST',
      TimerPaused() => 'PAUSED',
      TimerCompleted() => 'COMPLETE',
      TimerIdle() => 'READY',
    };

    final remaining = switch (state.phase) {
      TimerWarmup(:final remaining) => remaining,
      TimerWork(:final remaining) => remaining,
      TimerRest(:final remaining) => remaining,
      TimerPaused(:final previousPhase) => switch (previousPhase) {
          TimerWarmup(:final remaining) => remaining,
          TimerWork(:final remaining) => remaining,
          TimerRest(:final remaining) => remaining,
          _ => Duration.zero,
        },
      _ => Duration.zero,
    };

    if (state.phase is TimerCompleted) {
      audioService.clearNotification();
      onSessionEnd();
      return;
    }

    audioService.updateNotification(
      currentRound: state.currentRound,
      totalRounds: state.totalRounds,
      phaseLabel: phaseLabel,
      remaining: remaining,
    );
  }

  Future<void> _enableWakeLock() async {
    if (!_wakeLockEnabled) {
      await WakelockPlus.enable();
      _wakeLockEnabled = true;
    }
  }

  Future<void> _disableWakeLock() async {
    if (_wakeLockEnabled) {
      await WakelockPlus.disable();
      _wakeLockEnabled = false;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_wakeLockEnabled) {
      WakelockPlus.disable();
    }
  }
}
