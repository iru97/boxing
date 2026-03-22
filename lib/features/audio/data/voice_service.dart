import 'dart:async';

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
  bool _isSpeaking = false;
  Timer? _speakingTimeoutTimer;
  static const _maxSpeakingDuration = Duration(seconds: 5);

  /// Whether the TTS engine is currently speaking.
  bool get isSpeaking => _isSpeaking;

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
      await _tts.setPitch(1.05);

      // Track speaking state to prevent overlap
      _tts.setCompletionHandler(() {
        _isSpeaking = false;
        _speakingTimeoutTimer?.cancel();
      });
      _tts.setErrorHandler((msg) {
        debugPrint('VoiceService: TTS error: $msg');
        _isSpeaking = false;
        _speakingTimeoutTimer?.cancel();
      });
      _tts.setCancelHandler(() {
        _isSpeaking = false;
        _speakingTimeoutTimer?.cancel();
      });

      // Best-effort voice selection: prefer enhanced/premium voices
      await _selectBestVoice(locale);

      _initialized = true;
      debugPrint('VoiceService: initialized (locale=$locale)');
    } catch (e) {
      debugPrint('VoiceService: init failed: $e');
    }
  }

  /// Select the highest-quality voice for the given locale.
  ///
  /// Scores voices by name (enhanced/premium/neural/wavenet get +10) and
  /// locale match (exact match gets +2). Falls back silently if voice
  /// selection fails — the default system voice is acceptable.
  Future<void> _selectBestVoice(String locale) async {
    try {
      final voices = await _tts.getVoices;
      if (voices == null) return;

      final voiceList = List<Map<String, String>>.from(
        (voices as List).map((v) => Map<String, String>.from(v as Map)),
      );

      final targetLang = (_ttsLanguages[locale] ?? 'en-US').split('-')[0].toLowerCase();
      final targetLocale = (_ttsLanguages[locale] ?? 'en-US').toLowerCase();

      // Filter to voices that match the language
      final matching = voiceList.where((v) {
        final voiceLocale = (v['locale'] ?? '').toLowerCase();
        return voiceLocale.startsWith(targetLang);
      }).toList();

      if (matching.isEmpty) return;

      // Score each voice
      var bestScore = -1;
      Map<String, String>? bestVoice;

      for (final voice in matching) {
        var score = 0;
        final name = (voice['name'] ?? '').toLowerCase();
        final voiceLocale = (voice['locale'] ?? '').toLowerCase();

        // Prefer enhanced/premium/neural/wavenet voices
        if (name.contains('enhanced') ||
            name.contains('premium') ||
            name.contains('neural') ||
            name.contains('wavenet')) {
          score += 10;
        }

        // Prefer exact locale match (e.g. en-US over en-GB)
        if (voiceLocale == targetLocale) {
          score += 2;
        }

        if (score > bestScore) {
          bestScore = score;
          bestVoice = voice;
        }
      }

      if (bestVoice != null) {
        await _tts.setVoice({
          'name': bestVoice['name']!,
          'locale': bestVoice['locale']!,
        });
        debugPrint('VoiceService: selected voice ${bestVoice['name']} '
            '(locale=${bestVoice['locale']}, score=$bestScore)');
      }
    } catch (e) {
      debugPrint('VoiceService: voice selection failed (using default): $e');
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
  ///
  /// Phase announcements are high priority and always interrupt ongoing speech.
  Future<void> announce(VoiceEvent event) async {
    if (!_initialized) return;

    final text = _buildText(event);
    if (text.isEmpty) return;

    try {
      // Phase announcements always interrupt — higher priority than combos
      _isSpeaking = true;
      _speakingTimeoutTimer?.cancel();
      await _tts.stop();
      await _tts.setPitch(1.0); // Neutral pitch for round announcements
      await _tts.setSpeechRate(0.5);
      await _tts.speak(text);
      _speakingTimeoutTimer = Timer(_maxSpeakingDuration, () {
        _isSpeaking = false;
      });
    } catch (e) {
      _isSpeaking = false;
      debugPrint('VoiceService: announce failed: $e');
    }
  }

  /// Speak a combo callout at a faster speech rate.
  /// [rate] controls speed: 0.6 (relaxed) to 0.9 (hurricane).
  ///
  /// Skips the callout if the engine is already speaking (no queuing).
  /// This prevents overlap when combos fire faster than TTS can finish.
  Future<void> speakCombo(String text, {double rate = 0.7}) async {
    if (!_initialized) return;
    if (_isSpeaking) return; // Skip — don't queue, don't interrupt
    try {
      _isSpeaking = true;
      _speakingTimeoutTimer?.cancel();
      await _tts.setPitch(1.1); // Slightly urgent pitch for combos
      await _tts.setSpeechRate(rate);
      await _tts.speak(text);
      // Fallback timeout in case TTS completion handler doesn't fire
      _speakingTimeoutTimer = Timer(_maxSpeakingDuration, () {
        _isSpeaking = false;
      });
    } catch (e) {
      _isSpeaking = false;
      debugPrint('VoiceService: speakCombo failed: $e');
    }
  }

  /// Speak a motivational interjection with energetic TTS settings.
  /// Skipped if already speaking (same skip-if-busy policy as combos).
  Future<void> speakInterjection(String text) async {
    if (!_initialized) return;
    if (_isSpeaking) return; // Same skip-if-busy policy as combos
    try {
      _isSpeaking = true;
      _speakingTimeoutTimer?.cancel();
      await _tts.setPitch(1.15); // More energetic than combos (1.1)
      await _tts.setSpeechRate(0.65); // Deliberate cadence, not hurried
      await _tts.speak(text);
      _speakingTimeoutTimer = Timer(_maxSpeakingDuration, () {
        _isSpeaking = false;
      });
    } catch (e) {
      _isSpeaking = false;
      debugPrint('VoiceService: speakInterjection failed: $e');
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
      _isSpeaking = false;
      _speakingTimeoutTimer?.cancel();
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    _isSpeaking = false;
    _speakingTimeoutTimer?.cancel();
    await _tts.stop();
  }
}
