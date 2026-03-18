import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:boxing/features/audio/data/audio_player_service.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/timer/domain/timer_engine.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';
import 'package:boxing/features/timer/presentation/checkpoint_controller.dart';

/// Manages lifecycle events, wake lock, notification updates,
/// and checkpoint writes for the timer during active sessions.
class TimerLifecycleService with WidgetsBindingObserver {
  final TimerEngine engine;
  final BoxingAudioService audioService;
  final CheckpointController checkpointController;
  final SessionModel session;
  final bool keepScreenOn;

  bool _wakeLockEnabled = false;
  DateTime? _lastNotificationUpdate;
  String? _lastPhaseType;
  StreamSubscription<TimerState>? _stateSubscription;

  TimerLifecycleService({
    required this.engine,
    required this.audioService,
    required this.checkpointController,
    required this.session,
    this.keepScreenOn = true,
  });

  /// Call when a session starts.
  Future<void> onSessionStart() async {
    WidgetsBinding.instance.addObserver(this);
    if (keepScreenOn) {
      await _enableWakeLock();
    }
    await audioService.startKeepAlive();

    // Listen to timer state for notification updates and checkpoint writes
    _stateSubscription = engine.stateStream.listen(_onTimerStateUpdate);
  }

  /// Call when a session ends or is stopped.
  Future<void> onSessionEnd() async {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    WidgetsBinding.instance.removeObserver(this);
    await _disableWakeLock();
    await audioService.stopKeepAlive();
    await audioService.clearNotification();
    await checkpointController.clearCheckpoint();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App going to background or being killed — save checkpoint
        _writeCheckpoint();
        break;
      case AppLifecycleState.resumed:
        // App returning to foreground — timer auto-resyncs via DateTime
        break;
      case AppLifecycleState.inactive:
        // System dialog or phone call — save checkpoint
        _writeCheckpoint();
        break;
    }
  }

  void _onTimerStateUpdate(TimerState state) {
    // Write checkpoint on phase type changes
    final phaseType = _phaseTypeKey(state.phase);
    if (phaseType != _lastPhaseType) {
      _lastPhaseType = phaseType;
      _writeCheckpoint();
    }

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
      TimerSegment(:final isWarning, :final segmentLabel) =>
        isWarning ? 'WARNING' : (segmentLabel.isNotEmpty ? segmentLabel.toUpperCase() : 'WORK'),
      TimerRest() => 'REST',
      TimerPaused() => 'PAUSED',
      TimerCompleted() => 'COMPLETE',
      TimerIdle() => 'READY',
    };

    final remaining = switch (state.phase) {
      TimerWarmup(:final remaining) => remaining,
      TimerWork(:final remaining) => remaining,
      TimerSegment(:final remaining) => remaining,
      TimerRest(:final remaining) => remaining,
      TimerPaused(:final previousPhase) => switch (previousPhase) {
          TimerWarmup(:final remaining) => remaining,
          TimerWork(:final remaining) => remaining,
          TimerSegment(:final remaining) => remaining,
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

  String _phaseTypeKey(TimerPhase phase) {
    return switch (phase) {
      TimerWarmup() => 'warmup',
      TimerWork(:final roundNumber) => 'work_$roundNumber',
      TimerSegment(:final roundNumber, :final segmentIndex) =>
        'segment_${roundNumber}_$segmentIndex',
      TimerRest(:final afterRound) => 'rest_$afterRound',
      TimerPaused() => 'paused',
      TimerCompleted() => 'completed',
      TimerIdle() => 'idle',
    };
  }

  void _writeCheckpoint() {
    // Fire-and-forget — don't block the timer tick
    checkpointController.saveCheckpoint(engine, session);
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
    _stateSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    if (_wakeLockEnabled) {
      WakelockPlus.disable();
    }
  }
}
