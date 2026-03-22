import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:boxing/features/combos/domain/combo_model.dart';
import 'package:boxing/features/combos/domain/combo_callout_config.dart';
import 'package:boxing/features/combos/domain/technique.dart';

/// A combo selected for callout, with resolved display and TTS text.
class ComboCallout {
  final Combo combo;
  final String displayText;
  final String ttsText;

  const ComboCallout({
    required this.combo,
    required this.displayText,
    required this.ttsText,
  });
}

/// Drives combo callouts during work phases.
///
/// Uses DateTime-based timing (matching the app's timer engine pattern)
/// to decide when to emit the next combo. The engine does NOT own a
/// periodic timer -- instead it is driven by [onTick] calls from the
/// timer engine's existing 50ms tick loop.
///
/// Key behaviors:
/// - 3-second initial delay after work phase starts before first combo.
/// - Random interval between combos based on intensity.
/// - No combo during warning zone or within 3s before warning starts.
/// - Never repeats the same combo consecutively.
/// - Emits combos via a broadcast [StreamController].
class ComboCalloutEngine {
  final Map<String, Technique> _techniques;
  final math.Random _rng;

  List<Combo> _pool = [];
  ComboCalloutConfig _config = const ComboCalloutConfig();
  String _locale = 'en';

  // Timing state
  DateTime? _nextCalloutTime;
  bool _paused = false;
  Duration _pauseRemainingToNext = Duration.zero;

  // Combo state
  final ListQueue<String> _recentIds = ListQueue<String>();
  Combo? _lastFiredCombo;
  int _combosFired = 0;

  final _controller = StreamController<ComboCallout?>.broadcast();

  /// Interval ranges per intensity (min seconds, max seconds).
  static const _intervals = {
    ComboIntensity.relaxed: (min: 8, max: 12),
    ComboIntensity.moderate: (min: 5, max: 8),
    ComboIntensity.intense: (min: 3, max: 5),
    ComboIntensity.hurricane: (min: 2, max: 3),
  };

  /// Grace period before first combo after phase start.
  static const _initialDelaySec = 3;

  /// Safety buffer: don't call a combo within this many seconds of the
  /// warning zone start (avoids combo overlapping with warning bell).
  static const _warningBufferSec = 3;

  /// Recency window sizes per difficulty — prevents combo repetition perception.
  static const _recencyWindowBeginner = 3;
  static const _recencyWindowIntermediate = 4;
  static const _recencyWindowAdvanced = 5;

  /// Last N seconds of a round where combos fire faster to build intensity.
  static const _escalationZoneSec = 20;

  // Round-over-round progression context (set via setRoundContext,
  // read externally via progressiveDifficulty — kept for future
  // internal use such as adaptive combo selection).
  // ignore: unused_field
  int _currentRound = 1;
  // ignore: unused_field
  int _totalRounds = 1;

  ComboCalloutEngine({
    required Map<String, Technique> techniques,
    math.Random? rng,
  })  : _techniques = techniques,
        _rng = rng ?? math.Random();

  /// Stream of combo callouts. Emits null when the phase ends to clear the
  /// display. UI and voice service subscribe here.
  Stream<ComboCallout?> get comboStream => _controller.stream;

  /// Total number of combos fired in the current session.
  int get combosFired => _combosFired;

  /// Update configuration and rebuild the combo pool.
  void configure(ComboCalloutConfig config, List<Combo> combos, {String locale = 'en'}) {
    _config = config;
    _locale = locale;
    _pool = List.of(combos);
    _recentIds.clear();
    // Don't reset _combosFired here — progressive difficulty calls configure()
    // on each round transition. Reset only at session start via resetStats().
  }

  /// Reset session-level stats. Call once at the start of a new session.
  void resetStats() {
    _combosFired = 0;
  }

  /// Set the current round context for round-over-round difficulty progression.
  void setRoundContext(int currentRound, int totalRounds) {
    _currentRound = currentRound;
    _totalRounds = totalRounds;
  }

  /// Compute effective difficulty for a given round, ramping from beginner
  /// toward [configuredMax] across the session.
  ///
  /// - Single-round sessions always use [configuredMax].
  /// - 'beginner' max stays beginner throughout.
  /// - 'intermediate' max: first half beginner, second half intermediate.
  /// - 'advanced' max: first third beginner, second third intermediate,
  ///   final third advanced.
  static String progressiveDifficulty(
    int currentRound,
    int totalRounds,
    String configuredMax,
  ) {
    if (totalRounds <= 1) return configuredMax;
    if (configuredMax == 'beginner') return 'beginner';

    final fraction = (currentRound - 1) / (totalRounds - 1);

    if (configuredMax == 'intermediate') {
      return fraction < 0.5 ? 'beginner' : 'intermediate';
    }

    // advanced
    if (fraction < 0.34) return 'beginner';
    if (fraction < 0.67) return 'intermediate';
    return 'advanced';
  }

  /// Minimum seconds before next callout, based on combo technique count.
  /// Base 1.5s (hear + react) + 0.5s per technique beyond 2.
  static double _minIntervalForCombo(Combo combo) {
    final count = combo.techniqueIds.length;
    if (count <= 2) return 1.5;
    return 1.5 + (count - 2) * 0.5;
  }

  /// Called when a work (or segment) phase begins.
  void onWorkPhaseStart(DateTime now) {
    if (!_config.enabled || _pool.isEmpty) return;
    _paused = false;
    _nextCalloutTime = now.add(const Duration(seconds: _initialDelaySec));
    _recentIds.clear();
  }

  /// Called on every timer tick (~50ms). [remaining] is time left in the
  /// current work phase; [warningTime] is the session's warning threshold.
  void onTick(DateTime now, Duration remaining, Duration warningTime) {
    if (!_config.enabled || _paused || _pool.isEmpty) return;
    if (_nextCalloutTime == null) return;

    // Don't fire combos inside the warning zone
    if (warningTime > Duration.zero && remaining <= warningTime) return;

    // Don't fire if remaining time is too short (within warning buffer)
    final bufferThreshold = warningTime + const Duration(seconds: _warningBufferSec);
    if (remaining <= bufferThreshold) {
      // Cancel any pending callout -- we're too close to the end
      _nextCalloutTime = null;
      return;
    }

    if (now.isAfter(_nextCalloutTime!) || now.isAtSameMomentAs(_nextCalloutTime!)) {
      _fireCombo();
      _scheduleNext(now, remaining, warningTime);
    }
  }

  /// Called when the timer pauses.
  void onPause(DateTime now) {
    if (_nextCalloutTime == null) {
      _pauseRemainingToNext = Duration.zero;
    } else {
      _pauseRemainingToNext = _nextCalloutTime!.difference(now);
      if (_pauseRemainingToNext.isNegative) {
        _pauseRemainingToNext = Duration.zero;
      }
    }
    _paused = true;
  }

  /// Called when the timer resumes.
  void onResume(DateTime now) {
    _paused = false;
    if (_pauseRemainingToNext > Duration.zero) {
      _nextCalloutTime = now.add(_pauseRemainingToNext);
    }
  }

  /// Called when the current phase ends (rest, complete, etc.).
  /// Emits null so the UI clears the last displayed combo.
  void onPhaseEnd() {
    _nextCalloutTime = null;
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }

  /// Release resources.
  void dispose() {
    _controller.close();
  }

  // --- Private ---

  void _fireCombo() {
    final combo = _pickCombo();
    if (combo == null) return;

    _lastFiredCombo = combo;
    _combosFired++;
    final callout = ComboCallout(
      combo: combo,
      displayText: combo.displayText(_techniques),
      ttsText: combo.ttsTextForStyle(_techniques, _locale, _config.calloutStyle),
    );

    if (!_controller.isClosed) {
      _controller.add(callout);
    }
  }

  /// Pick a random combo from the pool, avoiding recent repeats via a FIFO
  /// recency window sized by difficulty.
  Combo? _pickCombo() {
    if (_pool.isEmpty) return null;
    if (_pool.length == 1) return _pool.first;

    final windowMax = _effectiveWindowSize();
    final window = math.min(windowMax, _pool.length - 1);

    final valid = _pool.where((c) => !_recentIds.contains(c.id)).toList();
    final candidates = valid.isEmpty ? _pool : valid;
    final combo = candidates[_rng.nextInt(candidates.length)];

    _recentIds.addLast(combo.id);
    if (_recentIds.length > window) _recentIds.removeFirst();

    return combo;
  }

  int _effectiveWindowSize() {
    switch (_config.difficulty) {
      case 'intermediate':
        return _recencyWindowIntermediate;
      case 'advanced':
        return _recencyWindowAdvanced;
      default:
        return _recencyWindowBeginner;
    }
  }

  void _scheduleNext(DateTime now, Duration remaining, Duration warningTime) {
    final intensity = _parseIntensity(_config.intensity);
    final bufferThreshold = warningTime + const Duration(seconds: _warningBufferSec);

    // E2: End-of-round escalation — use proportionally tighter intervals near round end
    final escalationStart = bufferThreshold + const Duration(seconds: _escalationZoneSec);
    final inEscalation = remaining <= escalationStart && remaining > bufferThreshold;
    final escalationIntensity = _escalationIntensityFor(intensity);
    final range = inEscalation ? _intervals[escalationIntensity]! : _intervals[intensity]!;

    var intervalSec = range.min + _rng.nextInt(range.max - range.min + 1);

    // E1: Combo-length minimum interval — give the user time to execute
    if (_lastFiredCombo != null) {
      final minInterval = _minIntervalForCombo(_lastFiredCombo!);
      if (intervalSec < minInterval) {
        intervalSec = minInterval.ceil();
      }
    }

    final candidate = now.add(Duration(seconds: intervalSec));

    // Check that the next callout wouldn't land in the warning buffer
    final timeAtCandidate = remaining - Duration(seconds: intervalSec);
    if (timeAtCandidate <= bufferThreshold) {
      // Not enough time for another combo -- stop scheduling
      _nextCalloutTime = null;
      return;
    }

    _nextCalloutTime = candidate;
  }

  static ComboIntensity _escalationIntensityFor(ComboIntensity configured) {
    switch (configured) {
      case ComboIntensity.relaxed:
        return ComboIntensity.moderate;
      case ComboIntensity.moderate:
        return ComboIntensity.intense;
      case ComboIntensity.intense:
      case ComboIntensity.hurricane:
        return ComboIntensity.hurricane;
    }
  }

  static ComboIntensity _parseIntensity(String value) {
    switch (value) {
      case 'relaxed':
        return ComboIntensity.relaxed;
      case 'intense':
        return ComboIntensity.intense;
      case 'hurricane':
        return ComboIntensity.hurricane;
      case 'moderate':
      default:
        return ComboIntensity.moderate;
    }
  }
}
