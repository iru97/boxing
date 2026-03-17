import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/sessions/presentation/sessions_controller.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';
import 'package:boxing/features/timer/presentation/timer_controller.dart';
import 'package:boxing/features/timer/presentation/widgets/countdown_display.dart';
import 'package:boxing/features/timer/presentation/widgets/phase_label.dart';
import 'package:boxing/features/timer/presentation/widgets/progress_ring.dart';
import 'package:boxing/features/timer/presentation/widgets/round_indicator.dart';
import 'package:boxing/features/timer/presentation/widgets/timer_controls.dart';

class TimerScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const TimerScreen({super.key, required this.sessionId});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  SessionModel? _session;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    // Session is looked up in build via provider
  }

  void _startSession() {
    final session = _session;
    if (session == null) return;

    final engine = ref.read(timerEngineProvider);
    final audioService = ref.read(audioServiceProvider);
    audioService.preload(soundPack: session.soundPack);
    engine.start(session);
    setState(() => _started = true);
  }

  void _confirmStop() {
    final state = ref.read(timerStateProvider).valueOrNull;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End Workout?'),
        content: Text(
          state != null
              ? 'You\'re on round ${state.currentRound} of ${state.totalRounds}.'
              : 'Are you sure you want to stop?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              ref.read(timerEngineProvider).stop();
              Navigator.of(ctx).pop();
              context.go('/');
            },
            child: const Text('END'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _session ??= ref.read(sessionByIdProvider(widget.sessionId));

    if (_session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Timer')),
        body: const Center(child: Text('Session not found')),
      );
    }

    if (!_started) {
      return _SessionSummaryView(
        session: _session!,
        onStart: _startSession,
        onBack: () => context.go('/'),
      );
    }

    final asyncState = ref.watch(timerStateProvider);

    return asyncState.when(
      data: (timerState) => _ActiveTimerView(
        session: _session!,
        timerState: timerState,
        onPauseResume: () {
          final engine = ref.read(timerEngineProvider);
          if (engine.isPaused) {
            engine.resume();
          } else {
            engine.pause();
          }
        },
        onSkipBack: () => ref.read(timerEngineProvider).skipBack(),
        onSkipForward: () => ref.read(timerEngineProvider).skipForward(),
        onStop: _confirmStop,
        onRepeat: _startSession,
        onDone: () {
          ref.read(timerEngineProvider).stop();
          context.go('/');
        },
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Timer error')),
      ),
    );
  }
}

/// Pre-workout session summary screen
class _SessionSummaryView extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const _SessionSummaryView({
    required this.session,
    required this.onStart,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(session.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              _SummaryRow('Rounds', '${session.rounds}'),
              _SummaryRow(
                'Round Duration',
                DurationFormatter.formatSeconds(session.roundDurationSec),
              ),
              _SummaryRow(
                'Rest Duration',
                DurationFormatter.formatSeconds(session.restDurationSec),
              ),
              if (session.warningTimeSec > 0)
                _SummaryRow(
                  'Warning',
                  '${session.warningTimeSec}s before end',
                ),
              if (session.warmupDurationSec > 0)
                _SummaryRow(
                  'Warmup',
                  DurationFormatter.formatSeconds(session.warmupDurationSec),
                ),
              const SizedBox(height: 24),
              _SummaryRow(
                'Total Time',
                DurationFormatter.format(session.totalDuration),
                bold: true,
              ),
              const Spacer(flex: 2),
              SizedBox(
                height: 80,
                child: FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: TimerColors.work,
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('START'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// Active timer view during workout
class _ActiveTimerView extends StatelessWidget {
  final SessionModel session;
  final TimerState timerState;
  final VoidCallback onPauseResume;
  final VoidCallback onSkipBack;
  final VoidCallback onSkipForward;
  final VoidCallback onStop;
  final VoidCallback onRepeat;
  final VoidCallback onDone;

  const _ActiveTimerView({
    required this.session,
    required this.timerState,
    required this.onPauseResume,
    required this.onSkipBack,
    required this.onSkipForward,
    required this.onStop,
    required this.onRepeat,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    // Handle completed state
    if (timerState.phase is TimerCompleted) {
      return _SessionCompleteView(
        sessionName: timerState.sessionName,
        totalRounds: timerState.totalRounds,
        totalElapsed: timerState.totalElapsed,
        onRepeat: onRepeat,
        onDone: onDone,
      );
    }

    final phaseInfo = _extractPhaseInfo(timerState.phase);
    final phaseColor = phaseInfo.color;
    final remaining = phaseInfo.remaining;
    final phaseName = phaseInfo.name;
    final isPaused = timerState.phase is TimerPaused;

    // Calculate progress
    final phaseDurationSec = _getPhaseDurationSec(timerState.phase, session);
    final progress = phaseDurationSec > 0
        ? remaining.inMilliseconds / (phaseDurationSec * 1000)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with stop button
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  color: Colors.white.withValues(alpha: 0.7),
                  onPressed: onStop,
                ),
              ),
            ),

            const Spacer(),

            // Round indicator
            RoundIndicator(
              currentRound: timerState.currentRound,
              totalRounds: timerState.totalRounds,
            ),

            const SizedBox(height: 32),

            // Progress ring with countdown inside
            ProgressRing(
              progress: progress.clamp(0.0, 1.0),
              color: phaseColor,
              child: CountdownDisplay(
                remaining: remaining,
                color: phaseColor,
              ),
            ),

            const SizedBox(height: 24),

            // Phase label
            PhaseLabel(
              label: isPaused ? 'PAUSED' : phaseName,
              color: phaseColor,
            ),

            const Spacer(),

            // Controls
            TimerControls(
              isPaused: isPaused,
              accentColor: phaseColor,
              onPauseResume: onPauseResume,
              onSkipBack: onSkipBack,
              onSkipForward: onSkipForward,
            ),

            const SizedBox(height: 24),

            // Total elapsed
            Text(
              'Total: ${DurationFormatter.format(timerState.totalElapsed)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  int _getPhaseDurationSec(TimerPhase phase, SessionModel session) {
    return switch (phase) {
      TimerWarmup() => session.warmupDurationSec,
      TimerWork(:final roundNumber) => session.durationForRound(roundNumber),
      TimerRest() => session.restDurationSec,
      TimerPaused(:final previousPhase) =>
        _getPhaseDurationSec(previousPhase, session),
      _ => 0,
    };
  }

  _PhaseInfo _extractPhaseInfo(TimerPhase phase) {
    return switch (phase) {
      TimerIdle() => _PhaseInfo(
          name: 'READY',
          color: TimerColors.idle,
          remaining: Duration.zero,
        ),
      TimerWarmup(:final remaining) => _PhaseInfo(
          name: 'WARMUP',
          color: TimerColors.warmup,
          remaining: remaining,
        ),
      TimerWork(:final remaining, :final isWarning) => _PhaseInfo(
          name: 'WORK',
          color: isWarning ? TimerColors.warning : TimerColors.work,
          remaining: remaining,
        ),
      TimerRest(:final remaining) => _PhaseInfo(
          name: 'REST',
          color: TimerColors.rest,
          remaining: remaining,
        ),
      TimerPaused(:final previousPhase) => () {
          final inner = _extractPhaseInfo(previousPhase);
          return _PhaseInfo(
            name: 'PAUSED',
            color: TimerColors.paused,
            remaining: inner.remaining,
          );
        }(),
      TimerCompleted() => _PhaseInfo(
          name: 'COMPLETE',
          color: TimerColors.complete,
          remaining: Duration.zero,
        ),
    };
  }
}

class _PhaseInfo {
  final String name;
  final Color color;
  final Duration remaining;

  const _PhaseInfo({
    required this.name,
    required this.color,
    required this.remaining,
  });
}

/// Session complete screen
class _SessionCompleteView extends StatelessWidget {
  final String sessionName;
  final int totalRounds;
  final Duration totalElapsed;
  final VoidCallback onRepeat;
  final VoidCallback onDone;

  const _SessionCompleteView({
    required this.sessionName,
    required this.totalRounds,
    required this.totalElapsed,
    required this.onRepeat,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(
                Icons.check_circle_outline,
                size: 96,
                color: TimerColors.work,
              ),
              const SizedBox(height: 24),
              const Text(
                'WORKOUT COMPLETE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                sessionName,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$totalRounds rounds completed',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total time: ${DurationFormatter.format(totalElapsed)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 64,
                width: double.infinity,
                child: FilledButton(
                  onPressed: onRepeat,
                  style: FilledButton.styleFrom(
                    backgroundColor: TimerColors.work,
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('REPEAT'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 64,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onDone,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('DONE'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
