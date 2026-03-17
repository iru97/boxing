import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/theme/app_typography.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/sessions/presentation/sessions_controller.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';
import 'package:boxing/features/timer/data/timer_lifecycle_service.dart';
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
  TimerLifecycleService? _lifecycleService;

  @override
  void initState() {
    super.initState();
    // Session is looked up in build via provider
  }

  @override
  void dispose() {
    _lifecycleService?.onSessionEnd();
    _lifecycleService?.dispose();
    super.dispose();
  }

  Future<void> _startSession() async {
    final session = _session;
    if (session == null) return;

    final engine = ref.read(timerEngineProvider);
    final audioService = ref.read(audioServiceProvider);

    // Attach engine to audio handler for notification media controls
    audioService.handler?.attachEngine(engine);

    // Pre-load sounds before starting (await to avoid missing first bell)
    await audioService.preload(soundPack: session.soundPack);

    engine.start(session);

    // Wire lifecycle service for wake lock, keep-alive, and notifications
    _lifecycleService = TimerLifecycleService(
      engine: engine,
      audioService: audioService,
    );
    await _lifecycleService!.onSessionStart();

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
              _lifecycleService?.onSessionEnd();
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
        appBar: AppBar(
          title: const Text('Timer'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
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

    // Use engine's current state as fallback during loading
    final timerState = asyncState.valueOrNull ??
        ref.read(timerEngineProvider).currentState;

    return _ActiveTimerView(
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
        _lifecycleService?.onSessionEnd();
        context.go('/');
      },
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
      backgroundColor: AppColors.background,
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

/// Active timer view during workout — tracks phase changes for flash effect.
class _ActiveTimerView extends StatefulWidget {
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
  State<_ActiveTimerView> createState() => _ActiveTimerViewState();
}

class _ActiveTimerViewState extends State<_ActiveTimerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<double> _flashOpacity;
  String? _lastPhaseKey;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _flashOpacity = Tween<double>(begin: 0.30, end: 0.0).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeOut),
    );
    _lastPhaseKey = _phaseKey(widget.timerState.phase);
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ActiveTimerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newKey = _phaseKey(widget.timerState.phase);
    if (newKey != _lastPhaseKey) {
      _lastPhaseKey = newKey;
      _flashController.forward(from: 0.0);
    }
  }

  /// Unique key per phase type + round so flash fires on phase transitions.
  String _phaseKey(TimerPhase phase) {
    return switch (phase) {
      TimerWarmup() => 'warmup',
      TimerWork(:final roundNumber) => 'work_$roundNumber',
      TimerRest(:final afterRound) => 'rest_$afterRound',
      TimerPaused(:final previousPhase) => 'paused_${_phaseKey(previousPhase)}',
      TimerCompleted() => 'complete',
      TimerIdle() => 'idle',
    };
  }

  @override
  Widget build(BuildContext context) {
    final timerState = widget.timerState;

    // Handle completed state
    if (timerState.phase is TimerCompleted) {
      return _SessionCompleteView(
        sessionName: timerState.sessionName,
        totalRounds: timerState.totalRounds,
        totalElapsed: timerState.totalElapsed,
        onRepeat: widget.onRepeat,
        onDone: widget.onDone,
      );
    }

    final phaseInfo = _extractPhaseInfo(timerState.phase);
    final phaseColor = phaseInfo.color;
    final remaining = phaseInfo.remaining;
    final phaseName = phaseInfo.name;
    final isPaused = timerState.phase is TimerPaused;

    // Calculate progress
    final phaseDurationSec =
        _getPhaseDurationSec(timerState.phase, widget.session);
    final progress = phaseDurationSec > 0
        ? remaining.inMilliseconds / (phaseDurationSec * 1000)
        : 0.0;

    // Phase background tint: 10% phase color over true black
    final tintedBackground = Color.alphaBlend(
      phaseColor.withValues(alpha: 0.10),
      AppColors.background,
    );

    return Scaffold(
      backgroundColor: tintedBackground,
      body: Stack(
        children: [
          SafeArea(
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
                      onPressed: widget.onStop,
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
                  onPauseResume: widget.onPauseResume,
                  onSkipBack: widget.onSkipBack,
                  onSkipForward: widget.onSkipForward,
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

          // Phase transition flash overlay
          AnimatedBuilder(
            animation: _flashOpacity,
            builder: (context, _) => _flashOpacity.value > 0
                ? Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color:
                            Colors.white.withValues(alpha: _flashOpacity.value),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
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

/// Session complete screen with radial pulse animation and proper typography.
class _SessionCompleteView extends StatefulWidget {
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
  State<_SessionCompleteView> createState() => _SessionCompleteViewState();
}

class _SessionCompleteViewState extends State<_SessionCompleteView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    // Play one pulse then stop
    _pulseController.forward().then((_) => _pulseController.reverse());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AnimatedBuilder(
                animation: _pulseScale,
                builder: (context, child) => Transform.scale(
                  scale: _pulseScale.value,
                  child: child,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 96,
                  color: TimerColors.work,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'SESSION COMPLETE',
                style: AppTypography.phaseLabel(Colors.white),
              ),
              const SizedBox(height: 32),
              Text(
                widget.sessionName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.totalRounds} rounds completed',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total time: ${DurationFormatter.format(widget.totalElapsed)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
              ),
              const Spacer(),
              SizedBox(
                height: 64,
                width: double.infinity,
                child: FilledButton(
                  onPressed: widget.onRepeat,
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
                  onPressed: widget.onDone,
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
