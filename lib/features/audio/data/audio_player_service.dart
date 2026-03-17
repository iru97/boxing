import 'package:just_audio/just_audio.dart';

import 'package:boxing/features/timer/domain/timer_engine.dart';

/// Foreground audio playback for boxing bell sounds.
/// Background audio support will be added in Sprint 4.
class BoxingAudioService {
  AudioPlayer? _roundStartPlayer;
  AudioPlayer? _warningPlayer;
  AudioPlayer? _roundEndPlayer;
  AudioPlayer? _sessionCompletePlayer;

  bool _loaded = false;

  /// Pre-load all sounds for a sound pack.
  Future<void> preload({String soundPack = 'classic_bell'}) async {
    try {
      _roundStartPlayer = AudioPlayer();
      _warningPlayer = AudioPlayer();
      _roundEndPlayer = AudioPlayer();
      _sessionCompletePlayer = AudioPlayer();

      await Future.wait([
        _roundStartPlayer!.setAsset('assets/sounds/round_start.wav'),
        _warningPlayer!.setAsset('assets/sounds/warning.wav'),
        _roundEndPlayer!.setAsset('assets/sounds/round_end.wav'),
        _sessionCompletePlayer!.setAsset('assets/sounds/session_complete.wav'),
      ]);
      _loaded = true;
    } catch (e) {
      // Audio load failure is non-fatal — timer continues without sound
      _loaded = false;
    }
  }

  /// Handle an audio cue from the timer engine.
  Future<void> playCue(AudioCue cue) async {
    if (!_loaded) return;

    try {
      switch (cue) {
        case AudioCue.roundStart:
          await _roundStartPlayer?.seek(Duration.zero);
          await _roundStartPlayer?.play();
        case AudioCue.warning:
          await _warningPlayer?.seek(Duration.zero);
          await _warningPlayer?.play();
        case AudioCue.roundEnd:
          await _roundEndPlayer?.seek(Duration.zero);
          await _roundEndPlayer?.play();
        case AudioCue.sessionComplete:
          await _sessionCompletePlayer?.seek(Duration.zero);
          await _sessionCompletePlayer?.play();
      }
    } catch (_) {
      // Fire-and-forget — don't let audio failures block the timer
    }
  }

  Future<void> dispose() async {
    await _roundStartPlayer?.dispose();
    await _warningPlayer?.dispose();
    await _roundEndPlayer?.dispose();
    await _sessionCompletePlayer?.dispose();
    _loaded = false;
  }
}
