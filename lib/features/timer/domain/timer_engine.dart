import 'dart:async';

import 'package:clock/clock.dart';

import 'package:boxing/features/audio/data/voice_service.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/timer/domain/timer_checkpoint.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';

/// Callback for audio cue triggers.
enum AudioCue { roundStart, warning, roundEnd, sessionComplete }

/// Callback when the engine needs user interaction to advance.
/// Fired when autoAdvance is false and a rest period ends.
typedef WaitForAdvanceCallback = void Function();

/// Core timer engine. Pure Dart, no Flutter dependencies.
/// Uses DateTime anchoring for drift-free timing.
class TimerEngine {
  final Clock _clock;
  final void Function(AudioCue)? onAudioCue;
  final void Function(VoiceEvent)? onVoiceAnnounce;

  /// Called when autoAdvance is false and the engine is waiting for a manual
  /// advance after rest completes. The UI should show a "tap to start next
  /// round" prompt and call [advanceFromWait] when ready.
  WaitForAdvanceCallback? onWaitForAdvance;

  Timer? _ticker;
  SessionModel? _session;

  // Phase tracking
  DateTime? _phaseStartTime;
  Duration _phaseDuration = Duration.zero;
  Duration _pausedElapsed = Duration.zero;

  // Session tracking
  DateTime? _sessionStartTime;
  int _currentRound = 0;
  bool _warningFired = false;
  _EnginePhase _enginePhase = _EnginePhase.idle;
  bool _waitingForAdvance = false;

  // Compound round segment tracking
  int _currentSegmentIndex = 0;
  List<RoundSegment>? _expandedSegments;

  // Pause state
  DateTime? _pausedAt;
  TimerPhase? _phaseBeforePause;

  final _controller = StreamController<TimerState>.broadcast();

  TimerEngine({Clock? clock, this.onAudioCue, this.onVoiceAnnounce})
      : _clock = clock ?? const Clock();

  Stream<TimerState> get stateStream => _controller.stream;

  TimerState get currentState => _buildState();

  bool get isRunning => _ticker != null && _enginePhase != _EnginePhase.idle;

  bool get isPaused => _pausedAt != null;

  bool get isWaitingForAdvance => _waitingForAdvance;

  /// Call when the user taps to advance after autoAdvance=false rest.
  void advanceFromWait() {
    if (!_waitingForAdvance || _session == null) return;
    _waitingForAdvance = false;
    _startNextWorkPhase();
    _startTicker();
  }

  void start(SessionModel session) {
    stop();
    _session = session;
    _sessionStartTime = _clock.now();
    _currentRound = 0;
    _warningFired = false;
    _currentSegmentIndex = 0;
    _expandedSegments = null; // resolved per-round in _startNextWorkPhase

    if (session.warmupDurationSec > 0) {
      _startPhase(_EnginePhase.warmup, Duration(seconds: session.warmupDurationSec));
      onVoiceAnnounce?.call(const VoiceEvent(VoiceEventType.warmup));
    } else {
      _startNextWorkPhase();
    }

    _startTicker();
  }

  void pause() {
    if (_pausedAt != null ||
        _enginePhase == _EnginePhase.idle ||
        _enginePhase == _EnginePhase.completed) {
      return;
    }

    _pausedAt = _clock.now();
    _pausedElapsed += _pausedAt!.difference(_phaseStartTime!);
    _phaseBeforePause = _buildCurrentPhase();
    _ticker?.cancel();
    _ticker = null;
    _emit();
  }

  void resume() {
    if (_pausedAt == null) return;

    // Reset phase start and store accumulated elapsed
    _phaseStartTime = _clock.now();
    final elapsed = _pausedElapsed;
    _pausedElapsed = Duration.zero;

    // Adjust: phaseStartTime is set to now, but we need to account for
    // time already spent in this phase before pause
    _phaseStartTime = _phaseStartTime!.subtract(elapsed);

    _pausedAt = null;
    _phaseBeforePause = null;
    _startTicker();
    _emit();
  }

  void stop() {
    _ticker?.cancel();
    _ticker = null;
    _session = null;
    _phaseStartTime = null;
    _sessionStartTime = null;
    _pausedAt = null;
    _phaseBeforePause = null;
    _pausedElapsed = Duration.zero;
    _currentRound = 0;
    _warningFired = false;
    _waitingForAdvance = false;
    _enginePhase = _EnginePhase.idle;
    _currentSegmentIndex = 0;
    _expandedSegments = null;
    _emit();
  }

  /// Resume from a previously saved checkpoint. Always restores as paused
  /// so the user can review their position and tap to continue.
  void resumeFromCheckpoint(TimerCheckpoint checkpoint, SessionModel session) {
    stop();
    _session = session;
    _currentRound = checkpoint.currentRound;
    _warningFired = checkpoint.warningFired;
    _waitingForAdvance = checkpoint.waitingForAdvance;
    _currentSegmentIndex = checkpoint.currentSegmentIndex;

    // Resolve segments for current round
    final template = session.templateForRound(_currentRound);
    _expandedSegments = template?.expandedSegments;

    // Parse saved engine phase
    _enginePhase = _EnginePhase.values.byName(checkpoint.enginePhase);

    final now = _clock.now();
    _phaseDuration = Duration(milliseconds: checkpoint.phaseDurationMs);
    _sessionStartTime = now.subtract(Duration(seconds: checkpoint.totalElapsedSec));

    // Always restore as paused — user must tap resume to continue
    final elapsed = _phaseDuration -
        Duration(milliseconds: checkpoint.phaseRemainingMs);
    _pausedElapsed = elapsed;
    _phaseStartTime = now;
    _pausedAt = now;
    _phaseBeforePause = _buildCurrentPhase();
    _emit();
  }

  void skipForward() {
    if (_pausedAt != null || _session == null) return;
    if (_enginePhase == _EnginePhase.completed || _enginePhase == _EnginePhase.idle) return;

    if (_enginePhase == _EnginePhase.segment) {
      // In segment mode, skip to next segment within the round
      if (_currentSegmentIndex < _expandedSegments!.length - 1) {
        _currentSegmentIndex++;
        final seg = _expandedSegments![_currentSegmentIndex];
        _startPhase(_EnginePhase.segment, Duration(seconds: seg.durationSec));
        onAudioCue?.call(AudioCue.roundStart);
        onVoiceAnnounce?.call(VoiceEvent(
          VoiceEventType.segmentStart,
          segmentLabel: seg.label,
        ));
        return;
      }
      // On last segment, skip forward completes the round
    }
    _onPhaseComplete();
  }

  void skipBack() {
    if (_pausedAt != null || _session == null) return;
    if (_enginePhase == _EnginePhase.completed || _enginePhase == _EnginePhase.idle) return;

    if (_enginePhase == _EnginePhase.warmup) {
      // Restart warmup
      _startPhase(_EnginePhase.warmup, Duration(seconds: _session!.warmupDurationSec));
    } else if (_enginePhase == _EnginePhase.rest && _expandedSegments != null) {
      // During rest after a compound round: go to last segment of the round
      _currentSegmentIndex = _expandedSegments!.length - 1;
      final seg = _expandedSegments![_currentSegmentIndex];
      _startPhase(_EnginePhase.segment, Duration(seconds: seg.durationSec));
      onAudioCue?.call(AudioCue.roundStart);
    } else if (_enginePhase == _EnginePhase.rest) {
      // During rest after round N: go back to round N work phase
      final roundDuration = Duration(seconds: _session!.durationForRound(_currentRound));
      _startPhase(_EnginePhase.work, roundDuration);
      onAudioCue?.call(AudioCue.roundStart);
    } else if (_enginePhase == _EnginePhase.segment) {
      // During segment mode: go to previous segment, or restart current one
      if (_currentSegmentIndex > 0) {
        _currentSegmentIndex--;
      }
      final seg = _expandedSegments![_currentSegmentIndex];
      _startPhase(_EnginePhase.segment, Duration(seconds: seg.durationSec));
      onAudioCue?.call(AudioCue.roundStart);
    } else if (_enginePhase == _EnginePhase.work) {
      // During work: restart current round (don't go to previous)
      final roundDuration = Duration(seconds: _session!.durationForRound(_currentRound));
      _startPhase(_EnginePhase.work, roundDuration);
      onAudioCue?.call(AudioCue.roundStart);
    }
  }

  void dispose() {
    _ticker?.cancel();
    _controller.close();
  }

  // --- Private ---

  Duration get _remaining {
    if (_phaseStartTime == null) return _phaseDuration;
    if (_pausedAt != null) {
      // While paused, remaining is phaseDuration - pausedElapsed
      return _phaseDuration - _pausedElapsed;
    }
    final elapsed = _clock.now().difference(_phaseStartTime!);
    final left = _phaseDuration - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  Duration get _totalElapsed {
    if (_sessionStartTime == null) return Duration.zero;
    return _clock.now().difference(_sessionStartTime!);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (_) => _onTick());
  }

  void _onTick() {
    if (_pausedAt != null) return;

    final remaining = _remaining;

    // Check warning threshold (during work phase, or last segment of compound round)
    if ((_enginePhase == _EnginePhase.work ||
            (_enginePhase == _EnginePhase.segment &&
                _currentSegmentIndex == _expandedSegments!.length - 1)) &&
        !_warningFired &&
        _session != null) {
      final warningTime = Duration(seconds: _session!.warningTimeSec);
      if (warningTime > Duration.zero && remaining <= warningTime) {
        _warningFired = true;
        onAudioCue?.call(AudioCue.warning);
      }
    }

    // Check phase completion
    if (remaining <= Duration.zero) {
      _onPhaseComplete();
      return;
    }

    _emit();
  }

  void _onPhaseComplete() {
    final session = _session!;

    switch (_enginePhase) {
      case _EnginePhase.warmup:
        _startNextWorkPhase();

      case _EnginePhase.work:
        onAudioCue?.call(AudioCue.roundEnd);
        if (_currentRound >= session.rounds) {
          // Session complete
          _enginePhase = _EnginePhase.completed;
          _ticker?.cancel();
          _ticker = null;
          onAudioCue?.call(AudioCue.sessionComplete);
          onVoiceAnnounce?.call(const VoiceEvent(VoiceEventType.complete));
          _emit();
        } else if (session.restDurationSec > 0) {
          _startPhase(_EnginePhase.rest, Duration(seconds: session.restDurationSec));
          onVoiceAnnounce?.call(const VoiceEvent(VoiceEventType.rest));
        } else {
          // No rest, go directly to next work phase
          _startNextWorkPhase();
        }

      case _EnginePhase.segment:
        // Check if there are more segments in this round
        if (_currentSegmentIndex < _expandedSegments!.length - 1) {
          _currentSegmentIndex++;
          final seg = _expandedSegments![_currentSegmentIndex];
          _startPhase(_EnginePhase.segment, Duration(seconds: seg.durationSec));
          if (seg.audioCue.isNotEmpty) {
            onAudioCue?.call(AudioCue.roundStart); // segment transition sound
          }
          onVoiceAnnounce?.call(VoiceEvent(
            VoiceEventType.segmentStart,
            segmentLabel: seg.label,
          ));
        } else {
          // All segments done = round complete
          onAudioCue?.call(AudioCue.roundEnd);
          _currentSegmentIndex = 0;
          if (_currentRound >= session.rounds) {
            _enginePhase = _EnginePhase.completed;
            _ticker?.cancel();
            _ticker = null;
            onAudioCue?.call(AudioCue.sessionComplete);
            onVoiceAnnounce?.call(const VoiceEvent(VoiceEventType.complete));
            _emit();
          } else if (session.restDurationSec > 0) {
            _startPhase(_EnginePhase.rest, Duration(seconds: session.restDurationSec));
            onVoiceAnnounce?.call(const VoiceEvent(VoiceEventType.rest));
          } else {
            _startNextWorkPhase();
          }
        }

      case _EnginePhase.rest:
        if (_session!.autoAdvance) {
          _startNextWorkPhase();
        } else {
          // Stop the ticker and wait for user to manually advance.
          _waitingForAdvance = true;
          _ticker?.cancel();
          _ticker = null;
          _emit();
          onWaitForAdvance?.call();
        }

      case _EnginePhase.idle:
      case _EnginePhase.completed:
        break;
    }
  }

  void _startNextWorkPhase() {
    _currentRound++;
    _currentSegmentIndex = 0;

    // Resolve template for THIS round (supports per-round overrides)
    final template = _session!.templateForRound(_currentRound);
    _expandedSegments = template?.expandedSegments;

    if (_expandedSegments != null) {
      final seg = _expandedSegments![0];
      _startPhase(_EnginePhase.segment, Duration(seconds: seg.durationSec));
      // Announce round number, then first segment label
      onVoiceAnnounce?.call(VoiceEvent(
        VoiceEventType.segmentStart,
        roundNumber: _currentRound,
        segmentLabel: seg.label,
      ));
    } else {
      final roundDuration = Duration(seconds: _session!.durationForRound(_currentRound));
      _startPhase(_EnginePhase.work, roundDuration);
      onVoiceAnnounce?.call(VoiceEvent(
        VoiceEventType.roundStart,
        roundNumber: _currentRound,
      ));
    }
    onAudioCue?.call(AudioCue.roundStart);
  }

  void _startPhase(_EnginePhase phase, Duration duration) {
    _enginePhase = phase;
    _phaseDuration = duration;
    _phaseStartTime = _clock.now();
    _pausedElapsed = Duration.zero;
    _warningFired = false;
    _emit();
  }

  TimerPhase _buildCurrentPhase() {
    final remaining = _remaining;
    switch (_enginePhase) {
      case _EnginePhase.idle:
        return const TimerPhase.idle();
      case _EnginePhase.warmup:
        return TimerPhase.warmup(remaining: remaining);
      case _EnginePhase.work:
        final isWarning = _session != null &&
            _session!.warningTimeSec > 0 &&
            remaining <= Duration(seconds: _session!.warningTimeSec);
        return TimerPhase.work(
          roundNumber: _currentRound,
          remaining: remaining,
          isWarning: isWarning,
        );
      case _EnginePhase.segment:
        final seg = _expandedSegments![_currentSegmentIndex];
        final isLastSegment =
            _currentSegmentIndex == _expandedSegments!.length - 1;
        final isWarning = isLastSegment &&
            _session != null &&
            _session!.warningTimeSec > 0 &&
            remaining <= Duration(seconds: _session!.warningTimeSec);
        return TimerPhase.segment(
          roundNumber: _currentRound,
          segmentIndex: _currentSegmentIndex,
          totalSegments: _expandedSegments!.length,
          segmentLabel: seg.label,
          remaining: remaining,
          isWarning: isWarning,
        );
      case _EnginePhase.rest:
        return TimerPhase.rest(afterRound: _currentRound, remaining: remaining);
      case _EnginePhase.completed:
        return TimerPhase.completed(totalRounds: _session?.rounds ?? 0);
    }
  }

  TimerState _buildState() {
    if (_pausedAt != null && _phaseBeforePause != null) {
      return TimerState(
        phase: TimerPhase.paused(previousPhase: _phaseBeforePause!),
        currentRound: _currentRound,
        totalRounds: _session?.rounds ?? 0,
        totalElapsed: _totalElapsed,
        sessionName: _session?.name ?? '',
      );
    }

    return TimerState(
      phase: _buildCurrentPhase(),
      currentRound: _currentRound,
      totalRounds: _session?.rounds ?? 0,
      totalElapsed: _totalElapsed,
      sessionName: _session?.name ?? '',
    );
  }

  void _emit() {
    if (!_controller.isClosed) {
      _controller.add(_buildState());
    }
  }
}

enum _EnginePhase { idle, warmup, work, segment, rest, completed }
