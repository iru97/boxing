import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:boxing/features/audio/data/boxing_audio_handler.dart';
import 'package:boxing/features/timer/domain/timer_engine.dart';

/// Audio service that supports both foreground and background playback.
/// In foreground mode, uses direct AudioPlayer.
/// In background mode (Sprint 4+), uses BoxingAudioHandler with foreground service.
class BoxingAudioService {
  BoxingAudioHandler? _handler;
  AudioPlayer? _fallbackPlayer;
  bool _useHandler = false;
  bool _loaded = false;

  /// Initialize with audio_service for background support.
  Future<void> initWithHandler() async {
    try {
      _handler = await AudioService.init(
        builder: () => BoxingAudioHandler(),
        config: AudioServiceConfig(
          androidNotificationChannelId: 'com.boxing.timer',
          androidNotificationChannelName: 'Boxing Timer',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: false,
          androidNotificationIcon: 'mipmap/ic_launcher',
        ),
      );
      _useHandler = true;
    } catch (_) {
      // Fall back to direct player if audio_service init fails
      _useHandler = false;
    }
  }

  /// Get the handler for engine attachment.
  BoxingAudioHandler? get handler => _handler;

  /// Pre-load sounds. For handler mode, sounds are loaded on demand.
  Future<void> preload({String soundPack = 'classic_bell'}) async {
    if (!_useHandler) {
      _fallbackPlayer = AudioPlayer();
    }
    _loaded = true;
  }

  /// Start keep-alive silent audio for background survival.
  Future<void> startKeepAlive() async {
    if (_useHandler) {
      await _handler?.startKeepAlive();
    }
  }

  /// Stop keep-alive.
  Future<void> stopKeepAlive() async {
    if (_useHandler) {
      await _handler?.stopKeepAlive();
    }
  }

  /// Play an audio cue.
  Future<void> playCue(AudioCue cue) async {
    if (!_loaded) return;

    try {
      if (_useHandler) {
        await _handler?.playCue(cue);
      } else {
        // Fallback: direct player
        final asset = switch (cue) {
          AudioCue.roundStart => 'assets/sounds/round_start.wav',
          AudioCue.warning => 'assets/sounds/warning.wav',
          AudioCue.roundEnd => 'assets/sounds/round_end.wav',
          AudioCue.sessionComplete => 'assets/sounds/session_complete.wav',
        };
        await _fallbackPlayer?.setAsset(asset);
        await _fallbackPlayer?.play();
      }
    } catch (_) {
      // Fire-and-forget
    }
  }

  /// Update notification (handler mode only).
  void updateNotification({
    required int currentRound,
    required int totalRounds,
    required String phaseLabel,
    required Duration remaining,
  }) {
    _handler?.updateNotification(
      currentRound: currentRound,
      totalRounds: totalRounds,
      phaseLabel: phaseLabel,
      remaining: remaining,
    );
  }

  /// Clear notification.
  void clearNotification() {
    _handler?.clearNotification();
  }

  Future<void> dispose() async {
    await _handler?.dispose();
    await _fallbackPlayer?.dispose();
    _loaded = false;
  }
}
