import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/timer/data/checkpoint_repository.dart';
import 'package:boxing/features/timer/domain/timer_checkpoint.dart';
import 'package:boxing/features/timer/domain/timer_engine.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';

/// Hive box provider (overridden in main.dart).
final checkpointBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('checkpointBoxProvider must be overridden');
});

/// Repository provider.
final checkpointRepositoryProvider = Provider<CheckpointRepository>((ref) {
  return CheckpointRepository(ref.watch(checkpointBoxProvider));
});

/// Invalidation counter for reactive updates.
final _checkpointInvalidator = StateProvider<int>((ref) => 0);

/// Current active checkpoint (null if none).
final activeCheckpointProvider = Provider<TimerCheckpoint?>((ref) {
  ref.watch(_checkpointInvalidator);
  return ref.watch(checkpointRepositoryProvider).get();
});

/// Controller for checkpoint operations.
final checkpointControllerProvider = Provider<CheckpointController>((ref) {
  return CheckpointController(ref);
});

class CheckpointController {
  final Ref _ref;

  CheckpointController(this._ref);

  CheckpointRepository get _repo => _ref.read(checkpointRepositoryProvider);

  /// Save a checkpoint from the current engine state.
  Future<void> saveCheckpoint(TimerEngine engine, SessionModel session) async {
    final checkpoint = _buildCheckpoint(engine, session);
    if (checkpoint == null) return;
    await _repo.save(checkpoint);
    _invalidate();
  }

  /// Clear the active checkpoint.
  Future<void> clearCheckpoint() async {
    await _repo.clear();
    _invalidate();
  }

  void _invalidate() {
    _ref.read(_checkpointInvalidator.notifier).state++;
  }

  TimerCheckpoint? _buildCheckpoint(TimerEngine engine, SessionModel session) {
    if (!engine.isRunning && !engine.isPaused && !engine.isWaitingForAdvance) {
      return null;
    }

    final state = engine.currentState;
    final enginePhase = _resolveEnginePhase(state.phase);
    if (enginePhase == null) return null;

    final remaining = _resolveRemaining(state.phase);

    return TimerCheckpoint(
      sessionId: session.id,
      sessionJson: jsonEncode(session.toJson()),
      enginePhase: enginePhase,
      currentRound: state.currentRound,
      currentSegmentIndex: _resolveSegmentIndex(state.phase),
      phaseRemainingMs: remaining.inMilliseconds,
      phaseDurationMs: _resolvePhaseDuration(state.phase, session),
      totalElapsedSec: state.totalElapsed.inSeconds,
      warningFired: _resolveWarningFired(state.phase),
      waitingForAdvance: engine.isWaitingForAdvance,
      checkpointTimestampMs: DateTime.now().millisecondsSinceEpoch,
      wasPaused: engine.isPaused,
      sessionName: session.name,
    );
  }

  String? _resolveEnginePhase(TimerPhase phase) {
    return switch (phase) {
      TimerWarmup() => 'warmup',
      TimerWork() => 'work',
      TimerSegment() => 'segment',
      TimerRest() => 'rest',
      TimerPaused(:final previousPhase) => _resolveEnginePhase(previousPhase),
      TimerCompleted() => null,
      TimerIdle() => null,
    };
  }

  Duration _resolveRemaining(TimerPhase phase) {
    return switch (phase) {
      TimerWarmup(:final remaining) => remaining,
      TimerWork(:final remaining) => remaining,
      TimerSegment(:final remaining) => remaining,
      TimerRest(:final remaining) => remaining,
      TimerPaused(:final previousPhase) => _resolveRemaining(previousPhase),
      _ => Duration.zero,
    };
  }

  int _resolveSegmentIndex(TimerPhase phase) {
    return switch (phase) {
      TimerSegment(:final segmentIndex) => segmentIndex,
      TimerPaused(:final previousPhase) => _resolveSegmentIndex(previousPhase),
      _ => 0,
    };
  }

  bool _resolveWarningFired(TimerPhase phase) {
    return switch (phase) {
      TimerWork(:final isWarning) => isWarning,
      TimerSegment(:final isWarning) => isWarning,
      TimerPaused(:final previousPhase) => _resolveWarningFired(previousPhase),
      _ => false,
    };
  }

  int _resolvePhaseDuration(TimerPhase phase, SessionModel session) {
    return switch (phase) {
      TimerWarmup() => session.warmupDurationSec * 1000,
      TimerWork(:final roundNumber) =>
        session.durationForRound(roundNumber) * 1000,
      TimerSegment(:final segmentIndex) => () {
          final segments = session.roundTemplate?.expandedSegments;
          if (segments != null && segmentIndex < segments.length) {
            return segments[segmentIndex].durationSec * 1000;
          }
          return 0;
        }(),
      TimerRest() => session.restDurationSec * 1000,
      TimerPaused(:final previousPhase) =>
        _resolvePhaseDuration(previousPhase, session),
      _ => 0,
    };
  }
}
