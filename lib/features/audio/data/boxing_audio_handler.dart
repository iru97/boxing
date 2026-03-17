import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:boxing/features/timer/domain/timer_engine.dart';

/// Custom AudioHandler that maintains a foreground service for the timer.
/// Plays bell sounds for phase transitions and loops silent audio to keep alive.
class BoxingAudioHandler extends BaseAudioHandler {
  final AudioPlayer _bellPlayer = AudioPlayer();
  final AudioPlayer _silentPlayer = AudioPlayer();
  TimerEngine? _engine;

  bool _silentLooping = false;

  /// Links this handler to the timer engine for media button controls.
  void attachEngine(TimerEngine engine) {
    _engine = engine;
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
    } catch (_) {
      // Non-fatal if silent audio fails
    }
  }

  /// Stop silent audio loop.
  Future<void> stopKeepAlive() async {
    _silentLooping = false;
    await _silentPlayer.stop();
  }

  /// Play a bell sound for an audio cue.
  Future<void> playCue(AudioCue cue) async {
    try {
      final asset = switch (cue) {
        AudioCue.roundStart => 'assets/sounds/round_start.wav',
        AudioCue.warning => 'assets/sounds/warning.wav',
        AudioCue.roundEnd => 'assets/sounds/round_end.wav',
        AudioCue.sessionComplete => 'assets/sounds/session_complete.wav',
      };
      await _bellPlayer.setAsset(asset);
      await _bellPlayer.setVolume(1.0);
      await _bellPlayer.play();
    } catch (_) {
      // Fire-and-forget
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
  void clearNotification() {
    playbackState.add(PlaybackState(
      processingState: AudioProcessingState.idle,
    ));
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
    await _bellPlayer.dispose();
    await _silentPlayer.dispose();
  }
}
