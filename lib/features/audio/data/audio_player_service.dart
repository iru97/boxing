import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'package:boxing/features/audio/data/boxing_audio_handler.dart';
import 'package:boxing/features/timer/domain/timer_engine.dart';

/// Audio service that supports both foreground and background playback.
/// In foreground mode, uses direct AudioPlayer.
/// In background mode (Sprint 4+), uses BoxingAudioHandler with foreground service.
///
/// Audio session is configured with [usage: alarm] so bell sounds route through
/// the alarm volume stream, which is almost never muted (unlike notification or
/// media streams).  This also enables audio ducking so Spotify/Apple Music
/// volume drops during bell cues.
class BoxingAudioService {
  BoxingAudioHandler? _handler;
  final Map<AudioCue, AudioPlayer> _fallbackPlayers = {};
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
      debugPrint('BoxingAudio: AudioService.init succeeded (handler mode)');
    } catch (e) {
      debugPrint('BoxingAudio: AudioService.init failed, using fallback: $e');
      _useHandler = false;
    }

    // Audio session is now configured per-session in preload() based on
    // the volumeOverride setting, so we don't set a default here.
  }

  /// Get the handler for engine attachment.
  BoxingAudioHandler? get handler => _handler;

  /// Asset path for each audio cue, parameterized by sound pack.
  static Map<AudioCue, String> _cueAssetsForPack(String pack) => {
    AudioCue.roundStart: 'assets/sounds/$pack/round_start.wav',
    AudioCue.warning: 'assets/sounds/$pack/warning.wav',
    AudioCue.roundEnd: 'assets/sounds/$pack/round_end.wav',
    AudioCue.sessionComplete: 'assets/sounds/$pack/session_complete.wav',
  };


  /// Reconfigure the audio session based on volumeOverride setting.
  ///
  /// When [volumeOverride] is true, routes audio through the alarm channel
  /// (independent of media volume, almost never muted). When false, uses
  /// the media channel (respects the user's media volume setting).
  Future<void> _configureAudioSession({required bool volumeOverride}) async {
    try {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionSetActiveOptions:
            AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: volumeOverride
              ? AndroidAudioUsage.alarm
              : AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
      ));
      debugPrint(
        'BoxingAudio: audio session configured '
        '(${volumeOverride ? "alarm" : "media"} stream, duck)',
      );
    } catch (e) {
      debugPrint('BoxingAudio: AudioSession config failed: $e');
    }
  }

  /// Pre-load sounds so first cue plays without latency.
  ///
  /// Also activates the audio session and sets the foreground service playback
  /// state to "playing" — both of which must happen BEFORE the first bell cue
  /// fires (which happens synchronously inside engine.start()).
  ///
  /// [volumeOverride] routes audio through the alarm channel for louder output.
  Future<void> preload({
    String soundPack = 'classic_bell',
    bool volumeOverride = false,
  }) async {
    // Configure audio session routing based on volumeOverride setting.
    await _configureAudioSession(volumeOverride: volumeOverride);

    try {
      if (_useHandler) {
        await _handler?.preloadAssets(soundPack: soundPack);
        // Activate audio session and set playback state BEFORE engine starts.
        // This ensures Android 14+ considers the foreground service valid
        // for audio output when the first bell cue fires.
        await _handler?.activateSession();
      } else {
        // Fallback: create one AudioPlayer per cue, with manual session mgmt.
        // Dispose old players if switching packs.
        for (final player in _fallbackPlayers.values) {
          await player.dispose();
        }
        _fallbackPlayers.clear();

        final assets = _cueAssetsForPack(soundPack);
        for (final cue in AudioCue.values) {
          final player = AudioPlayer(
            handleAudioSessionActivation: false,
          );
          await player.setAsset(assets[cue]!);
          await player.setVolume(1.0);
          _fallbackPlayers[cue] = player;
        }
        // Activate audio session for fallback path too.
        try {
          final session = await AudioSession.instance;
          await session.setActive(true);
        } catch (e) {
          debugPrint('BoxingAudio: fallback session activation failed: $e');
        }
      }
    } catch (e) {
      debugPrint('BoxingAudio: preload failed: $e');
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
    if (!_loaded) {
      debugPrint('BoxingAudio: playCue(${cue.name}) skipped — not loaded');
      return;
    }

    try {
      if (_useHandler) {
        await _handler?.playCue(cue);
      } else {
        // Fallback: use the dedicated player for this cue.
        final player = _fallbackPlayers[cue];
        if (player == null) {
          debugPrint('BoxingAudio: no fallback player for ${cue.name}');
          return;
        }
        await player.seek(Duration.zero);
        await player.play();
      }
    } catch (e) {
      debugPrint('BoxingAudio: playCue(${cue.name}) failed: $e');
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
  Future<void> clearNotification() async {
    await _handler?.clearNotification();
  }

  Future<void> dispose() async {
    await _handler?.dispose();
    for (final player in _fallbackPlayers.values) {
      await player.dispose();
    }
    _fallbackPlayers.clear();
    _loaded = false;
  }
}
