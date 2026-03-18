import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_checkpoint.freezed.dart';
part 'timer_checkpoint.g.dart';

@freezed
class TimerCheckpoint with _$TimerCheckpoint {
  const factory TimerCheckpoint({
    // Which session
    required String sessionId,
    required String sessionJson,

    // Engine position
    required String enginePhase, // 'warmup' | 'work' | 'segment' | 'rest'
    required int currentRound,
    required int currentSegmentIndex,
    required int phaseRemainingMs,
    required int phaseDurationMs,
    required int totalElapsedSec,
    required bool warningFired,
    required bool waitingForAdvance,

    // Wall-clock anchor
    required int checkpointTimestampMs,
    required bool wasPaused,

    // Metadata
    required String sessionName,
  }) = _TimerCheckpoint;

  factory TimerCheckpoint.fromJson(Map<String, dynamic> json) =>
      _$TimerCheckpointFromJson(json);
}
