import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/theme/app_typography.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:flutter/services.dart';

import 'package:boxing/features/ads/presentation/ads_controller.dart';
import 'package:boxing/features/audio/data/voice_service.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/sessions/presentation/sessions_controller.dart';
import 'package:boxing/features/settings/domain/app_settings.dart';
import 'package:boxing/features/settings/presentation/settings_controller.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';
import 'package:boxing/features/timer/data/timer_lifecycle_service.dart';
import 'package:boxing/features/combos/data/combo_library.dart';
import 'package:boxing/features/combos/data/technique_library.dart';
import 'package:boxing/features/combos/domain/combo_callout_engine.dart';
import 'package:boxing/features/combos/presentation/combo_callout_provider.dart';
import 'package:boxing/features/combos/presentation/combo_display_widget.dart';
import 'package:boxing/features/timer/presentation/timer_controller.dart';
import 'package:boxing/features/timer/presentation/widgets/countdown_display.dart';
import 'package:boxing/features/timer/presentation/widgets/phase_label.dart';
import 'package:boxing/features/timer/presentation/widgets/progress_ring.dart';
import 'package:boxing/features/timer/presentation/widgets/round_indicator.dart';
import 'package:boxing/features/timer/presentation/widgets/timer_controls.dart';
import 'package:boxing/features/history/presentation/history_controller.dart';
import 'package:boxing/features/timer/presentation/checkpoint_controller.dart';
import 'package:boxing/features/programs/presentation/programs_controller.dart';
import 'package:boxing/l10n/app_localizations.dart';

class TimerScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final bool resumeFromCheckpoint;

  /// Optional pre-resolved session (used for program workouts that are not
  /// stored in the session repository).
  final SessionModel? sessionOverride;

  /// When this workout belongs to a training program, these fields allow
  /// the timer to mark the program day as complete on session finish.
  final String? programId;
  final int? programWeekNum;
  final int? programDayNum;

  const TimerScreen({
    super.key,
    required this.sessionId,
    this.resumeFromCheckpoint = false,
    this.sessionOverride,
    this.programId,
    this.programWeekNum,
    this.programDayNum,
  });

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  SessionModel? _session;
  bool _started = false;
  bool _recordSaved = false;
  bool _programDayMarked = false;
  TimerLifecycleService? _lifecycleService;
  StreamSubscription<ComboCallout>? _comboSubscription;

  @override
  void initState() {
    super.initState();
    // Pre-set session from override (program workouts)
    _session = widget.sessionOverride;
    if (widget.resumeFromCheckpoint) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _resumeSession());
    }
  }

  @override
  void dispose() {
    _comboSubscription?.cancel();
    _lifecycleService?.onSessionEnd();
    _lifecycleService?.dispose();
    super.dispose();
  }

  Future<void> _startSession() async {
    final session = _session;
    if (session == null) return;

    final engine = ref.read(timerEngineProvider);
    final audioService = ref.read(audioServiceProvider);
    final checkpointCtrl = ref.read(checkpointControllerProvider);
    final settings = ref.read(appSettingsProvider);
    final voiceService = ref.read(voiceServiceProvider);
    final voiceLocale = settings.locale == 'system'
        ? Localizations.localeOf(context).languageCode
        : settings.locale;

    // Clear any existing checkpoint before starting a new session
    await checkpointCtrl.clearCheckpoint();

    // Attach engine to audio handler for notification media controls
    audioService.handler?.attachEngine(engine);

    // Pre-load sounds before starting (await to avoid missing first bell)
    await audioService.preload(
      soundPack: session.soundPack,
      volumeOverride: settings.volumeOverride,
    );

    // Set voice locale based on settings
    await voiceService.setLocale(voiceLocale);

    // Set active session so combo providers can resolve
    ref.read(activeSessionProvider.notifier).state = session;

    // Configure combo callout engine if enabled
    _comboSubscription?.cancel();
    final comboEngine = ref.read(comboCalloutEngineProvider);
    if (comboEngine != null && session.comboConfig != null) {
      comboEngine.configure(
        session.comboConfig!,
        ref.read(filteredCombosProvider(session.comboConfig!)),
        locale: voiceLocale,
      );
      // Subscribe to combo stream to speak callouts via TTS
      final speechRate = switch (session.comboConfig!.intensity) {
        'relaxed' => 0.6,
        'intense' => 0.8,
        'hurricane' => 0.9,
        _ => 0.7, // moderate
      };
      _comboSubscription = comboEngine.comboStream.listen((callout) {
        voiceService.speakCombo(callout.ttsText, rate: speechRate);
      });
    }

    _recordSaved = false;
    engine.start(session);

    // Wire lifecycle service for wake lock, keep-alive, checkpoint writes
    _lifecycleService?.dispose();
    _lifecycleService = TimerLifecycleService(
      engine: engine,
      audioService: audioService,
      checkpointController: checkpointCtrl,
      session: session,
      keepScreenOn: session.keepScreenOn,
    );
    await _lifecycleService!.onSessionStart();

    setState(() => _started = true);
  }

  Future<void> _resumeSession() async {
    final checkpoint = ref.read(activeCheckpointProvider);
    if (checkpoint == null) return;

    // Resolve session — try live lookup first, fall back to embedded JSON
    _session ??= ref.read(sessionByIdProvider(checkpoint.sessionId));
    _session ??= _decodeSessionFromCheckpoint(checkpoint);
    if (_session == null) {
      // Can't restore — clear stale checkpoint
      await ref.read(checkpointControllerProvider).clearCheckpoint();
      return;
    }

    final engine = ref.read(timerEngineProvider);
    final audioService = ref.read(audioServiceProvider);
    final checkpointCtrl = ref.read(checkpointControllerProvider);
    final settings = ref.read(appSettingsProvider);
    final voiceService = ref.read(voiceServiceProvider);
    final voiceLocale = settings.locale == 'system'
        ? Localizations.localeOf(context).languageCode
        : settings.locale;

    audioService.handler?.attachEngine(engine);
    await audioService.preload(
      soundPack: _session!.soundPack,
      volumeOverride: settings.volumeOverride,
    );

    // Set voice locale based on settings
    await voiceService.setLocale(voiceLocale);

    _recordSaved = false;
    engine.resumeFromCheckpoint(checkpoint, _session!);

    _lifecycleService?.dispose();
    _lifecycleService = TimerLifecycleService(
      engine: engine,
      audioService: audioService,
      checkpointController: checkpointCtrl,
      session: _session!,
      keepScreenOn: _session!.keepScreenOn,
    );
    await _lifecycleService!.onSessionStart();

    setState(() => _started = true);
  }

  SessionModel? _decodeSessionFromCheckpoint(dynamic checkpoint) {
    try {
      final json = checkpoint.sessionJson as String;
      final map = Map<String, dynamic>.from(
        const JsonDecoder().convert(json) as Map,
      );
      return SessionModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  void _confirmStop() {
    final state = ref.read(timerStateProvider).valueOrNull;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).timerEndWorkoutTitle),
        content: Text(
          state != null
              ? S.of(context).timerEndWorkoutMessage(state.currentRound, state.totalRounds)
              : S.of(context).timerStopConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(S.of(context).buttonCancel),
          ),
          TextButton(
            onPressed: () {
              // Pause, save checkpoint, and exit — user can resume later
              final engine = ref.read(timerEngineProvider);
              if (!engine.isPaused) engine.pause();
              // Write checkpoint explicitly
              if (_session != null) {
                ref.read(checkpointControllerProvider)
                    .saveCheckpoint(engine, _session!);
              }
              // Release wake lock and keep-alive but DON'T clear checkpoint
              _lifecycleService?.dispose();
              _lifecycleService = null;
              Navigator.of(ctx).pop();
              context.go('/');
            },
            child: Text(S.of(context).buttonSaveExit),
          ),
          TextButton(
            onPressed: () async {
              // Save partial training record before stopping
              final currentState = ref.read(timerStateProvider).valueOrNull ??
                  ref.read(timerEngineProvider).currentState;
              if (_session != null) {
                ref.read(historyControllerProvider).addRecord(
                  sessionId: _session!.id,
                  sessionName: _session!.name,
                  durationCompletedSec: currentState.totalElapsed.inSeconds,
                  roundsCompleted: currentState.currentRound,
                  totalRounds: currentState.totalRounds,
                  completedFully: false,
                );
              }
              ref.read(timerEngineProvider).stop();
              _lifecycleService?.onSessionEnd();
              Navigator.of(ctx).pop();
              await _navigateHomeWithAd();
            },
            child: Text(S.of(context).buttonEnd),
          ),
        ],
      ),
    );
  }

  /// Show interstitial at a natural transition (workout ended or stopped),
  /// then navigate to home. If the ad is not ready or on cooldown, navigates
  /// immediately. Does NOT show for "Save & Exit" flows.
  Future<void> _navigateHomeWithAd() async {
    final adService = ref.read(adServiceProvider);
    await adService.showInterstitialIfReady();
    if (mounted) {
      context.go('/');
    }
  }

  /// Track the previous phase key to detect transitions for combo engine.
  String? _lastComboPhaseKey;

  /// Drive the combo callout engine based on timer state changes.
  ///
  /// When entering a segment with [comboCategories], reconfigures the engine's
  /// combo pool to only include combos matching those technique categories.
  void _driveComboEngine(
    ComboCalloutEngine comboEngine,
    TimerState timerState,
    SessionModel session,
  ) {
    final now = DateTime.now();
    final phase = timerState.phase;
    final isWorkPhase = phase is TimerWork || phase is TimerSegment;

    // Determine the current phase key for transition detection
    final phaseKey = switch (phase) {
      TimerWork(:final roundNumber) => 'work_$roundNumber',
      TimerSegment(:final roundNumber, :final segmentIndex) =>
        'segment_${roundNumber}_$segmentIndex',
      TimerRest(:final afterRound) => 'rest_$afterRound',
      TimerPaused(:final previousPhase) => 'paused_${previousPhase.runtimeType}',
      TimerWarmup() => 'warmup',
      TimerCompleted() => 'complete',
      TimerIdle() => 'idle',
    };

    // Detect phase transitions
    if (phaseKey != _lastComboPhaseKey) {
      final oldKey = _lastComboPhaseKey;
      _lastComboPhaseKey = phaseKey;

      if (isWorkPhase) {
        comboEngine.onPhaseEnd();

        // Segment-aware combo pool: if this segment has comboCategories,
        // reconfigure the engine with a filtered pool
        if (phase is TimerSegment && session.comboConfig != null) {
          final segments = session.roundTemplate?.expandedSegments;
          final segIndex = phase.segmentIndex;
          if (segments != null && segIndex < segments.length) {
            final categories = segments[segIndex].comboCategories;
            if (categories != null && categories.isNotEmpty) {
              final fullPool = ref.read(filteredCombosProvider(session.comboConfig!));
              final filteredPool = ComboLibrary.filteredByCategories(
                pool: fullPool,
                categories: categories,
                techniques: TechniqueLibrary.all,
              );
              // Use filtered pool if non-empty, otherwise fall back to full pool
              final locale = ref.read(appSettingsProvider).locale == 'system'
                  ? Localizations.localeOf(context).languageCode
                  : ref.read(appSettingsProvider).locale;
              comboEngine.configure(
                session.comboConfig!,
                filteredPool.isNotEmpty ? filteredPool : fullPool,
                locale: locale,
              );
            }
          }
        }

        comboEngine.onWorkPhaseStart(now);
      } else if (phase is TimerPaused) {
        comboEngine.onPause(now);
      } else if (oldKey != null && oldKey.startsWith('paused_')) {
        comboEngine.onResume(now);
      } else {
        comboEngine.onPhaseEnd();
      }
    }

    // Drive tick for active work/segment phases
    if (isWorkPhase) {
      final remaining = switch (phase) {
        TimerWork(:final remaining) => remaining,
        TimerSegment(:final remaining) => remaining,
        _ => Duration.zero,
      };
      comboEngine.onTick(
        now,
        remaining,
        Duration(seconds: session.warningTimeSec),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _session ??= ref.read(sessionByIdProvider(widget.sessionId));

    if (_session == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).timerScreenTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: Center(child: Text(S.of(context).sessionNotFound)),
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

    // Auto-save training record on session complete
    if (timerState.phase is TimerCompleted && !_recordSaved && _session != null) {
      _recordSaved = true;
      ref.read(historyControllerProvider).addRecord(
        sessionId: _session!.id,
        sessionName: _session!.name,
        durationCompletedSec: timerState.totalElapsed.inSeconds,
        roundsCompleted: timerState.totalRounds,
        totalRounds: timerState.totalRounds,
        completedFully: true,
      );

      // Mark program day as complete if this is a program workout
      if (!_programDayMarked &&
          widget.programId != null &&
          widget.programWeekNum != null &&
          widget.programDayNum != null) {
        _programDayMarked = true;
        ref.read(programsControllerProvider).completeDay(
              widget.programId!,
              widget.programWeekNum!,
              widget.programDayNum!,
            );
      }
    }

    final settings = ref.watch(appSettingsProvider);

    // Drive combo callout engine with current timer state
    final comboEngine = ref.read(comboCalloutEngineProvider);
    if (comboEngine != null && _session != null) {
      _driveComboEngine(comboEngine, timerState, _session!);
    }

    return _ActiveTimerView(
      session: _session!,
      timerState: timerState,
      settings: settings,
      voiceService: ref.read(voiceServiceProvider),
      onPauseResume: () {
        final engine = ref.read(timerEngineProvider);
        if (engine.isPaused) {
          // Resume is handled by _ActiveTimerView when countdown is enabled
          engine.resume();
        } else {
          engine.pause();
        }
      },
      onAdvanceFromWait: () {
        ref.read(timerEngineProvider).advanceFromWait();
      },
      onSkipBack: () => ref.read(timerEngineProvider).skipBack(),
      onSkipForward: () => ref.read(timerEngineProvider).skipForward(),
      onStop: _confirmStop,
      onRepeat: _startSession,
      onDone: () async {
        ref.read(timerEngineProvider).stop();
        _lifecycleService?.onSessionEnd();
        await _navigateHomeWithAd();
      },
    );
  }
}

String _capitalizeFirst(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

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
              _SummaryRow(S.of(context).labelRounds, '${session.rounds}'),
              _SummaryRow(
                S.of(context).labelRoundDuration,
                DurationFormatter.formatSeconds(session.roundDurationSec),
              ),
              _SummaryRow(
                S.of(context).labelRestDuration,
                DurationFormatter.formatSeconds(session.restDurationSec),
              ),
              if (session.roundTemplate != null) ...[
                _SummaryRow(
                  S.of(context).labelRoundStructure,
                  session.roundTemplate!.name,
                ),
                _SummaryRow(
                  S.of(context).labelSegmentsPerRound,
                  '${session.roundTemplate!.expandedSegments.length}',
                ),
              ],
              if (session.warningTimeSec > 0)
                _SummaryRow(
                  S.of(context).labelWarning,
                  S.of(context).warningBeforeEnd(session.warningTimeSec),
                ),
              if (session.warmupDurationSec > 0)
                _SummaryRow(
                  S.of(context).labelWarmup,
                  DurationFormatter.formatSeconds(session.warmupDurationSec),
                ),
              if (session.comboConfig != null && session.comboConfig!.enabled)
                _SummaryRow(
                  S.of(context).comboSummaryLabel,
                  '${_capitalizeFirst(session.comboConfig!.sport)} - ${_capitalizeFirst(session.comboConfig!.difficulty)}',
                ),
              const SizedBox(height: 24),
              _SummaryRow(
                S.of(context).labelTotalTime,
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
                  child: Text(S.of(context).buttonStart),
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
  final AppSettings settings;
  final VoiceService voiceService;
  final VoidCallback onPauseResume;
  final VoidCallback onAdvanceFromWait;
  final VoidCallback onSkipBack;
  final VoidCallback onSkipForward;
  final VoidCallback onStop;
  final VoidCallback onRepeat;
  final VoidCallback onDone;

  const _ActiveTimerView({
    required this.session,
    required this.timerState,
    required this.settings,
    required this.voiceService,
    required this.onPauseResume,
    required this.onAdvanceFromWait,
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
    with TickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<double> _flashOpacity;
  String? _lastPhaseKey;

  // Resume countdown state
  int? _resumeCountdownValue; // null = not counting, 3/2/1 = active
  Timer? _resumeCountdownTimer;

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

  void _fireHaptic() {
    if (widget.settings.hapticFeedback) {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    _resumeCountdownTimer?.cancel();
    _flashController.dispose();
    super.dispose();
  }

  /// Handle pause/resume tap with optional 3-2-1 countdown.
  void _handlePauseResume() {
    final isPaused = widget.timerState.phase is TimerPaused;

    if (isPaused && widget.settings.resumeCountdown && _resumeCountdownValue == null) {
      // Start 3-2-1 countdown before resuming
      _startResumeCountdown();
    } else if (_resumeCountdownValue != null) {
      // Tapping during countdown cancels it and stays paused
      _cancelResumeCountdown();
    } else {
      widget.onPauseResume();
    }
  }

  void _startResumeCountdown() {
    setState(() => _resumeCountdownValue = 3);
    widget.voiceService.announce(
      const VoiceEvent(VoiceEventType.segmentStart, segmentLabel: '3'),
    );
    _resumeCountdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final next = (_resumeCountdownValue ?? 1) - 1;
        if (next <= 0) {
          timer.cancel();
          setState(() {
            _resumeCountdownValue = null;
            _resumeCountdownTimer = null;
          });
          widget.onPauseResume(); // actually resume
        } else {
          setState(() => _resumeCountdownValue = next);
          widget.voiceService.announce(
            VoiceEvent(VoiceEventType.segmentStart, segmentLabel: '$next'),
          );
        }
      },
    );
  }

  void _cancelResumeCountdown() {
    _resumeCountdownTimer?.cancel();
    setState(() {
      _resumeCountdownValue = null;
      _resumeCountdownTimer = null;
    });
  }

  @override
  void didUpdateWidget(covariant _ActiveTimerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newKey = _phaseKey(widget.timerState.phase);
    if (newKey != _lastPhaseKey) {
      _lastPhaseKey = newKey;
      _flashController.forward(from: 0.0);
      _fireHaptic();
    }
  }

  /// Unique key per phase type + round so flash fires on phase transitions.
  String _phaseKey(TimerPhase phase) {
    return switch (phase) {
      TimerWarmup() => 'warmup',
      TimerWork(:final roundNumber) => 'work_$roundNumber',
      TimerSegment(:final roundNumber, :final segmentIndex) =>
        'segment_${roundNumber}_$segmentIndex',
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

    final body = Stack(
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
                  label: isPaused ? S.of(context).phaseLabelPaused : phaseName,
                  color: phaseColor,
                ),

                // Segment indicator (compound rounds only)
                _buildSegmentIndicator(timerState.phase, phaseColor),

                const SizedBox(height: 8),

                // Combo callout display (shows active combo badges)
                const ComboDisplayWidget(),

                const Spacer(),

                // Controls
                TimerControls(
                  isPaused: isPaused,
                  accentColor: phaseColor,
                  onPauseResume: _handlePauseResume,
                  onSkipBack: widget.onSkipBack,
                  onSkipForward: widget.onSkipForward,
                ),

                const SizedBox(height: 24),

                // Total elapsed
                Text(
                  S.of(context).totalElapsedFormat(DurationFormatter.format(timerState.totalElapsed)),
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

          // Resume countdown overlay (3-2-1)
          if (_resumeCountdownValue != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: _cancelResumeCountdown,
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
                    child: Text(
                      '$_resumeCountdownValue',
                      style: const TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );

    return Scaffold(
      backgroundColor: tintedBackground,
      body: widget.settings.tapToPause
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _handlePauseResume,
              child: body,
            )
          : body,
    );
  }

  int _getPhaseDurationSec(TimerPhase phase, SessionModel session) {
    return switch (phase) {
      TimerWarmup() => session.warmupDurationSec,
      TimerWork(:final roundNumber) => session.durationForRound(roundNumber),
      TimerSegment(:final segmentIndex) => () {
          final segments = session.roundTemplate?.expandedSegments;
          if (segments != null && segmentIndex < segments.length) {
            return segments[segmentIndex].durationSec;
          }
          return 0;
        }(),
      TimerRest() => session.restDurationSec,
      TimerPaused(:final previousPhase) =>
        _getPhaseDurationSec(previousPhase, session),
      _ => 0,
    };
  }

  _PhaseInfo _extractPhaseInfo(TimerPhase phase) {
    final l = S.of(context);
    return switch (phase) {
      TimerIdle() => _PhaseInfo(
          name: l.phaseLabelReady,
          color: TimerColors.idle,
          remaining: Duration.zero,
        ),
      TimerWarmup(:final remaining) => _PhaseInfo(
          name: l.phaseLabelWarmup,
          color: TimerColors.warmup,
          remaining: remaining,
        ),
      TimerWork(:final remaining, :final isWarning) => _PhaseInfo(
          name: l.phaseLabelWork,
          color: isWarning ? TimerColors.warning : TimerColors.work,
          remaining: remaining,
        ),
      TimerSegment(
        :final remaining,
        :final isWarning,
        :final segmentLabel,
        :final segmentIndex,
      ) =>
        _PhaseInfo(
          name: segmentLabel.isNotEmpty ? segmentLabel.toUpperCase() : l.phaseLabelWork,
          color: isWarning
              ? TimerColors.warning
              : _segmentColor(segmentIndex),
          remaining: remaining,
        ),
      TimerRest(:final remaining) => _PhaseInfo(
          name: l.phaseLabelRest,
          color: TimerColors.rest,
          remaining: remaining,
        ),
      TimerPaused(:final previousPhase) => () {
          final inner = _extractPhaseInfo(previousPhase);
          return _PhaseInfo(
            name: l.phaseLabelPaused,
            color: TimerColors.paused,
            remaining: inner.remaining,
          );
        }(),
      TimerCompleted() => _PhaseInfo(
          name: l.phaseLabelComplete,
          color: TimerColors.complete,
          remaining: Duration.zero,
        ),
    };
  }

  Color _segmentColor(int segmentIndex) {
    final segments = widget.session.roundTemplate?.expandedSegments;
    if (segments == null || segmentIndex >= segments.length) {
      return TimerColors.work;
    }
    return switch (segments[segmentIndex].color) {
      'rest' => TimerColors.rest,
      'warning' => TimerColors.warning,
      'warmup' => TimerColors.warmup,
      _ => TimerColors.work,
    };
  }

  Widget _buildSegmentIndicator(TimerPhase phase, Color activeColor) {
    // Extract segment info — works for direct or paused states
    final segmentPhase = switch (phase) {
      TimerSegment() => phase,
      TimerPaused(:final previousPhase) when previousPhase is TimerSegment =>
        previousPhase,
      _ => null,
    };

    if (segmentPhase == null) return const SizedBox(height: 8);

    final total = segmentPhase.totalSegments;
    final current = segmentPhase.segmentIndex;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (i) {
          final isActive = i == current;
          final segColor = _segmentColor(i);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isActive
                    ? segColor
                    : segColor.withValues(alpha: 0.3),
              ),
            ),
          );
        }),
      ),
    );
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
                S.of(context).sessionCompleteTitle,
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
                S.of(context).sessionCompleteRounds(widget.totalRounds),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).sessionCompleteTotalTime(DurationFormatter.format(widget.totalElapsed)),
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
                  child: Text(S.of(context).buttonRepeat),
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
                  child: Text(S.of(context).buttonDone),
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
