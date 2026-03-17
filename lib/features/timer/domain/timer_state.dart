import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_state.freezed.dart';

@freezed
sealed class TimerPhase with _$TimerPhase {
  const factory TimerPhase.idle() = TimerIdle;
  const factory TimerPhase.warmup({required Duration remaining}) = TimerWarmup;
  const factory TimerPhase.work({
    required int roundNumber,
    required Duration remaining,
    required bool isWarning,
  }) = TimerWork;
  const factory TimerPhase.rest({
    required int afterRound,
    required Duration remaining,
  }) = TimerRest;
  const factory TimerPhase.paused({required TimerPhase previousPhase}) =
      TimerPaused;
  const factory TimerPhase.completed({required int totalRounds}) =
      TimerCompleted;
}

class TimerState {
  final TimerPhase phase;
  final int currentRound;
  final int totalRounds;
  final Duration totalElapsed;
  final String sessionName;

  const TimerState({
    required this.phase,
    required this.currentRound,
    required this.totalRounds,
    required this.totalElapsed,
    required this.sessionName,
  });

  const TimerState.initial()
      : phase = const TimerPhase.idle(),
        currentRound = 0,
        totalRounds = 0,
        totalElapsed = Duration.zero,
        sessionName = '';

  TimerState copyWith({
    TimerPhase? phase,
    int? currentRound,
    int? totalRounds,
    Duration? totalElapsed,
    String? sessionName,
  }) {
    return TimerState(
      phase: phase ?? this.phase,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      totalElapsed: totalElapsed ?? this.totalElapsed,
      sessionName: sessionName ?? this.sessionName,
    );
  }
}
