import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Voice announcement event fired by the timer engine.
class VoiceEvent {
  final VoiceEventType type;
  final int? roundNumber;
  final String? segmentLabel;

  const VoiceEvent(this.type, {this.roundNumber, this.segmentLabel});
}

enum VoiceEventType { warmup, roundStart, segmentStart, rest, complete }

/// TTS service that speaks phase announcements in the configured language.
class VoiceService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  String _locale = 'en';

  /// Localized phrase lookup: locale → event type → text.
  /// Round numbers and segment labels are interpolated at speak time.
  static const _phrases = {
    'en': {
      VoiceEventType.warmup: 'Warmup',
      VoiceEventType.roundStart: 'Round',
      VoiceEventType.rest: 'Rest',
      VoiceEventType.complete: 'Complete',
    },
    'es': {
      VoiceEventType.warmup: 'Calentamiento',
      VoiceEventType.roundStart: 'Round',
      VoiceEventType.rest: 'Descanso',
      VoiceEventType.complete: 'Completo',
    },
    'pt': {
      VoiceEventType.warmup: 'Aquecimento',
      VoiceEventType.roundStart: 'Round',
      VoiceEventType.rest: 'Descanso',
      VoiceEventType.complete: 'Completo',
    },
  };

  /// TTS language codes for flutter_tts.
  static const _ttsLanguages = {
    'en': 'en-US',
    'es': 'es-ES',
    'pt': 'pt-BR',
  };

  Future<void> init({String locale = 'en'}) async {
    if (_initialized) return;
    try {
      _locale = locale;
      await _tts.setLanguage(_ttsLanguages[locale] ?? 'en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _initialized = true;
      debugPrint('VoiceService: initialized (locale=$locale)');
    } catch (e) {
      debugPrint('VoiceService: init failed: $e');
    }
  }

  /// Update the TTS language (e.g. when settings change).
  Future<void> setLocale(String locale) async {
    _locale = locale;
    try {
      await _tts.setLanguage(_ttsLanguages[locale] ?? 'en-US');
    } catch (e) {
      debugPrint('VoiceService: setLocale failed: $e');
    }
  }

  /// Speak a voice announcement for the given event.
  Future<void> announce(VoiceEvent event) async {
    if (!_initialized) return;

    final text = _buildText(event);
    if (text.isEmpty) return;

    try {
      // Stop any ongoing speech before new announcement
      await _tts.stop();
      await _tts.setSpeechRate(0.5);
      await _tts.speak(text);
    } catch (e) {
      debugPrint('VoiceService: announce failed: $e');
    }
  }

  /// Speak a combo callout at a faster speech rate.
  /// [rate] controls speed: 0.6 (relaxed) to 0.9 (hurricane).
  Future<void> speakCombo(String text, {double rate = 0.7}) async {
    if (!_initialized) return;
    try {
      await _tts.stop();
      await _tts.setSpeechRate(rate);
      await _tts.speak(text);
      // Note: speech rate will be reset to 0.5 on next announce() call
    } catch (e) {
      debugPrint('VoiceService: speakCombo failed: $e');
    }
  }

  String _buildText(VoiceEvent event) {
    final phrases = _phrases[_locale] ?? _phrases['en']!;

    return switch (event.type) {
      VoiceEventType.warmup => phrases[VoiceEventType.warmup]!,
      VoiceEventType.roundStart =>
        '${phrases[VoiceEventType.roundStart]!} ${event.roundNumber ?? 1}',
      VoiceEventType.segmentStart => () {
          final label = event.segmentLabel ?? '';
          if (event.roundNumber != null) {
            // First segment of a new round: "Round 3, Bag Work"
            return '${phrases[VoiceEventType.roundStart]!} ${event.roundNumber}, $label';
          }
          // Mid-round segment transition: just the label
          return label;
        }(),
      VoiceEventType.rest => phrases[VoiceEventType.rest]!,
      VoiceEventType.complete => phrases[VoiceEventType.complete]!,
    };
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}
