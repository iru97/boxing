import 'dart:async';
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
  Combo? _lastCombo;

  final _controller = StreamController<ComboCallout>.broadcast();

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

  ComboCalloutEngine({
    required Map<String, Technique> techniques,
    math.Random? rng,
  })  : _techniques = techniques,
        _rng = rng ?? math.Random();

  /// Stream of combo callouts. UI and voice service subscribe here.
  Stream<ComboCallout> get comboStream => _controller.stream;

  /// Update configuration and rebuild the combo pool.
  void configure(ComboCalloutConfig config, List<Combo> combos, {String locale = 'en'}) {
    _config = config;
    _locale = locale;
    _pool = List.of(combos);
    _lastCombo = null;
  }

  /// Called when a work (or segment) phase begins.
  void onWorkPhaseStart(DateTime now) {
    if (!_config.enabled || _pool.isEmpty) return;
    _paused = false;
    _nextCalloutTime = now.add(const Duration(seconds: _initialDelaySec));
    _lastCombo = null;
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
  void onPhaseEnd() {
    _nextCalloutTime = null;
  }

  /// Release resources.
  void dispose() {
    _controller.close();
  }

  // --- Private ---

  void _fireCombo() {
    final combo = _pickCombo();
    if (combo == null) return;

    _lastCombo = combo;
    final callout = ComboCallout(
      combo: combo,
      displayText: combo.displayText(_techniques),
      ttsText: combo.ttsTextForLocale(_techniques, _locale),
    );

    if (!_controller.isClosed) {
      _controller.add(callout);
    }
  }

  /// Pick a random combo from the pool, avoiding consecutive repeats.
  Combo? _pickCombo() {
    if (_pool.isEmpty) return null;
    if (_pool.length == 1) return _pool.first;

    // Try up to 10 times to avoid repeating the last combo
    for (var i = 0; i < 10; i++) {
      final combo = _pool[_rng.nextInt(_pool.length)];
      if (combo.id != _lastCombo?.id) return combo;
    }
    // Fallback: return any combo that isn't the last one
    return _pool.firstWhere(
      (c) => c.id != _lastCombo?.id,
      orElse: () => _pool.first,
    );
  }

  void _scheduleNext(DateTime now, Duration remaining, Duration warningTime) {
    final intensity = _parseIntensity(_config.intensity);
    final range = _intervals[intensity]!;
    final intervalSec = range.min + _rng.nextInt(range.max - range.min + 1);
    final candidate = now.add(Duration(seconds: intervalSec));

    // Check that the next callout wouldn't land in the warning buffer
    final timeAtCandidate = remaining - Duration(seconds: intervalSec);
    final bufferThreshold = warningTime + const Duration(seconds: _warningBufferSec);
    if (timeAtCandidate <= bufferThreshold) {
      // Not enough time for another combo -- stop scheduling
      _nextCalloutTime = null;
      return;
    }

    _nextCalloutTime = candidate;
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
