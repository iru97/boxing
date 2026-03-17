import 'dart:async';

import 'package:clock/clock.dart';

import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';

/// Callback for audio cue triggers.
enum AudioCue { roundStart, warning, roundEnd, sessionComplete }

/// Core timer engine. Pure Dart, no Flutter dependencies.
/// Uses DateTime anchoring for drift-free timing.
class TimerEngine {
  final Clock _clock;
  final void Function(AudioCue)? onAudioCue;

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

  // Pause state
  DateTime? _pausedAt;
  TimerPhase? _phaseBeforePause;

  final _controller = StreamController<TimerState>.broadcast();

  TimerEngine({Clock? clock, this.onAudioCue}) : _clock = clock ?? const Clock();

  Stream<TimerState> get stateStream => _controller.stream;

  TimerState get currentState => _buildState();

  bool get isRunning => _ticker != null && _enginePhase != _EnginePhase.idle;

  bool get isPaused => _pausedAt != null;

  void start(SessionModel session) {
    stop();
    _session = session;
    _sessionStartTime = _clock.now();
    _currentRound = 0;
    _warningFired = false;

    if (session.warmupDurationSec > 0) {
      _startPhase(_EnginePhase.warmup, Duration(seconds: session.warmupDurationSec));
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
    _enginePhase = _EnginePhase.idle;
    _emit();
  }

  void skipForward() {
    if (_pausedAt != null || _session == null) return;
    if (_enginePhase == _EnginePhase.completed || _enginePhase == _EnginePhase.idle) return;

    _onPhaseComplete();
  }

  void skipBack() {
    if (_pausedAt != null || _session == null) return;
    if (_enginePhase == _EnginePhase.completed || _enginePhase == _EnginePhase.idle) return;

    // Restart current round's work phase
    if (_enginePhase == _EnginePhase.rest) {
      // During rest after round N, go back to round N work
    } else if (_enginePhase == _EnginePhase.work && _currentRound > 1) {
      _currentRound--;
    }
    // For warmup, just restart warmup

    if (_enginePhase == _EnginePhase.warmup) {
      _startPhase(_EnginePhase.warmup, Duration(seconds: _session!.warmupDurationSec));
    } else {
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

    // Check warning threshold (only during work phase)
    if (_enginePhase == _EnginePhase.work && !_warningFired && _session != null) {
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
          _emit();
        } else if (session.restDurationSec > 0) {
          _startPhase(_EnginePhase.rest, Duration(seconds: session.restDurationSec));
        } else {
          // No rest, go directly to next work phase
          _startNextWorkPhase();
        }

      case _EnginePhase.rest:
        _startNextWorkPhase();

      case _EnginePhase.idle:
      case _EnginePhase.completed:
        break;
    }
  }

  void _startNextWorkPhase() {
    _currentRound++;
    final roundDuration = Duration(seconds: _session!.durationForRound(_currentRound));
    _startPhase(_EnginePhase.work, roundDuration);
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

enum _EnginePhase { idle, warmup, work, rest, completed }
