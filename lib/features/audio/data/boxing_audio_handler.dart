import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'package:boxing/features/timer/domain/timer_engine.dart';

/// Asset paths for each audio cue, parameterized by sound pack.
Map<AudioCue, String> _cueAssetsForPack(String pack) => {
  AudioCue.roundStart: 'assets/sounds/$pack/round_start.wav',
  AudioCue.warning: 'assets/sounds/$pack/warning.wav',
  AudioCue.roundEnd: 'assets/sounds/$pack/round_end.wav',
  AudioCue.sessionComplete: 'assets/sounds/$pack/session_complete.wav',
};

/// Custom AudioHandler that maintains a foreground service for the timer.
/// Plays bell sounds for phase transitions and loops silent audio to keep alive.
///
/// Audio session activation is managed centrally here — individual AudioPlayers
/// have handleAudioSessionActivation disabled to prevent them from fighting
/// over session control (which causes silence on Samsung One UI).
class BoxingAudioHandler extends BaseAudioHandler {
  /// One dedicated AudioPlayer per cue — eliminates race conditions when
  /// rapid cues fire back-to-back (e.g. roundEnd + roundStart on skip).
  final Map<AudioCue, AudioPlayer> _cuePlayers = {};
  late final AudioPlayer _silentPlayer;
  TimerEngine? _engine;

  bool _silentLooping = false;

  BoxingAudioHandler() {
    // Silent player also opts out of auto session management.
    _silentPlayer = AudioPlayer(
      handleAudioSessionActivation: false,
    );
  }

  /// Links this handler to the timer engine for media button controls.
  void attachEngine(TimerEngine engine) {
    _engine = engine;
  }

  /// Pre-load every cue sound into its own AudioPlayer so first playback
  /// is latency-free and concurrent cues never collide.
  ///
  /// Players are created with [handleAudioSessionActivation: false] so they
  /// don't individually fight for audio focus — [activateSession] manages that.
  Future<void> preloadAssets({String soundPack = 'classic_bell'}) async {
    // Dispose previous players if switching packs
    for (final player in _cuePlayers.values) {
      await player.dispose();
    }
    _cuePlayers.clear();

    final assets = _cueAssetsForPack(soundPack);
    for (final cue in AudioCue.values) {
      try {
        final player = AudioPlayer(
          handleAudioSessionActivation: false,
        );
        await player.setAsset(assets[cue]!);
        await player.setVolume(1.0);
        _cuePlayers[cue] = player;
      } catch (e) {
        debugPrint('BoxingAudio: preload ${cue.name} failed: $e');
      }
    }
    debugPrint('BoxingAudio: preloaded ${_cuePlayers.length}/${AudioCue.values.length} cues ($soundPack)');
  }

  /// Activate the audio session and set playback state to playing.
  ///
  /// Must be called BEFORE any playCue() or startKeepAlive() call.
  /// This ensures Android's foreground service is in a valid "playing" state
  /// and the audio session is active — both required on Android 14+ Samsung
  /// devices for audio output from a mediaPlayback foreground service.
  Future<void> activateSession() async {
    try {
      final session = await AudioSession.instance;
      await session.setActive(true);
      debugPrint('BoxingAudio: audio session activated');
    } catch (e) {
      debugPrint('BoxingAudio: session activation failed: $e');
    }

    // Set playback state to "playing" so Android considers the foreground
    // service legitimate for mediaPlayback.  Without this, the very first
    // bell cue fires while the service is still in "idle" state, which
    // Android 14+ may suppress.
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.pause,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.play,
        MediaAction.pause,
        MediaAction.stop,
      },
      playing: true,
      processingState: AudioProcessingState.ready,
    ));
  }

  /// Deactivate audio session on session end.
  Future<void> deactivateSession() async {
    try {
      final session = await AudioSession.instance;
      await session.setActive(false);
    } catch (e) {
      debugPrint('BoxingAudio: session deactivation failed: $e');
    }
  }

  /// Start silent audio loop to keep the foreground service alive.
  Future<void> startKeepAlive() async {
    if (_silentLooping) return;
    try {
      await _silentPlayer.setAsset('assets/sounds/silence.wav');
      await _silentPlayer.setLoopMode(LoopMode.one);
      await _silentPlayer.setVolume(0.0);
      await _silentPlayer.play();
      _silentLooping = true;
    } catch (e) {
      debugPrint('BoxingAudio: silent keep-alive failed: $e');
    }
  }

  /// Stop silent audio loop.
  Future<void> stopKeepAlive() async {
    _silentLooping = false;
    await _silentPlayer.stop();
  }

  /// Play a bell sound for an audio cue.
  ///
  /// Uses seek-then-play (no stop) because just_audio's stop() clears the
  /// audio source, requiring setAsset() again.  Seeking to zero on a
  /// completed or playing player reliably restarts playback.
  Future<void> playCue(AudioCue cue) async {
    try {
      final player = _cuePlayers[cue];
      if (player == null) {
        debugPrint('BoxingAudio: no player for ${cue.name} — preloadAssets() not called?');
        return;
      }
      await player.seek(Duration.zero);
      await player.play();
    } catch (e) {
      debugPrint('BoxingAudio: playCue(${cue.name}) failed: $e');
    }
  }

  /// Update the notification with current timer state.
  void updateNotification({
    required int currentRound,
    required int totalRounds,
    required String phaseLabel,
    required Duration remaining,
  }) {
    final minutes = remaining.inSeconds ~/ 60;
    final seconds = remaining.inSeconds % 60;
    final timeStr = '$minutes:${seconds.toString().padLeft(2, '0')}';

    mediaItem.add(MediaItem(
      id: 'boxing_timer',
      title: 'Round $currentRound/$totalRounds - $phaseLabel',
      album: '$timeStr remaining',
      artUri: null,
      duration: remaining,
    ));

    // Update playback state
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        _engine?.isPaused == true ? MediaControl.play : MediaControl.pause,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.play,
        MediaAction.pause,
        MediaAction.stop,
        MediaAction.skipToPrevious,
        MediaAction.skipToNext,
      },
      playing: _engine?.isPaused != true,
      processingState: AudioProcessingState.ready,
    ));
  }

  /// Clear notification when session ends.
  Future<void> clearNotification() async {
    playbackState.add(PlaybackState(
      processingState: AudioProcessingState.idle,
    ));
    await deactivateSession();
  }

  // Media button handlers
  @override
  Future<void> play() async {
    _engine?.resume();
  }

  @override
  Future<void> pause() async {
    _engine?.pause();
  }

  @override
  Future<void> stop() async {
    _engine?.stop();
    await stopKeepAlive();
    await deactivateSession();
    await super.stop();
  }

  @override
  Future<void> skipToNext() async {
    _engine?.skipForward();
  }

  @override
  Future<void> skipToPrevious() async {
    _engine?.skipBack();
  }

  Future<void> dispose() async {
    for (final player in _cuePlayers.values) {
      await player.dispose();
    }
    _cuePlayers.clear();
    await _silentPlayer.dispose();
  }
}
