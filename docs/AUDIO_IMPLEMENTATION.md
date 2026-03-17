# Audio Implementation Guide - Boxing Timer App

Researched: 2026-03-17

---

## 1. Package Versions (Exact)

```yaml
dependencies:
  just_audio: ^0.10.5
  audio_service: ^0.18.18
  audio_session: ^0.2.2
  flutter_volume_controller: ^1.3.4
  sound_effect: ^0.1.3          # Optional: ultra-low-latency alternative
```

---

## 2. just_audio Setup and Usage

### Preloading Assets

```dart
final player = AudioPlayer();

// setAsset preloads by default (preload: true)
await player.setAsset('assets/audio/bell_round_end.wav');

// To load WITHOUT auto-playing:
await player.setAsset('assets/audio/bell_round_end.wav', preload: true);

// Now player is ready — play() will fire with minimal latency:
await player.play();
```

The `preload: true` parameter (default) decodes the audio and buffers it in memory. The `play()` call after preloading completes near-instantly because the audio data is already decoded.

### AudioPlayer Pool Pattern for Overlapping Sounds

`just_audio` does NOT have a built-in pool. A single `AudioPlayer` plays one source at a time. You must create multiple instances manually:

```dart
class AudioPlayerPool {
  final List<AudioPlayer> _players = [];
  final String assetPath;
  final int poolSize;

  AudioPlayerPool({required this.assetPath, this.poolSize = 3});

  Future<void> init() async {
    for (int i = 0; i < poolSize; i++) {
      final player = AudioPlayer();
      await player.setAsset(assetPath, preload: true);
      _players.add(player);
    }
  }

  Future<void> play() async {
    // Find an idle player (not currently playing)
    for (final player in _players) {
      if (!player.playing) {
        await player.seek(Duration.zero);
        await player.play();
        return;
      }
    }
    // All busy — reuse the first one (restart it)
    await _players.first.seek(Duration.zero);
    await _players.first.play();
  }

  Future<void> dispose() async {
    for (final player in _players) {
      await player.dispose();
    }
  }
}
```

### Alternative: `sound_effect` Package (Lower Latency)

The `sound_effect` package (by lichess.org) is purpose-built for short sound effects with minimal latency. Uses platform-native APIs (SoundPool on Android, AVAudioPlayer on iOS):

```dart
final sfx = SoundEffect();
await sfx.initialize();
await sfx.load('bell', 'assets/audio/bell_round_end.wav');
await sfx.load('warning', 'assets/audio/warning_10s.wav');

// Play with near-zero latency:
await sfx.play('bell');
await sfx.play('warning', volume: 0.5);

// Cleanup:
sfx.release();
```

**Limitation**: Android and iOS only (no web/desktop). GPL-3.0 license.

### Recommendation for Boxing Timer

Use a **hybrid approach**:
- `just_audio` + `audio_service` for the background audio/foreground service/notification layer
- `sound_effect` (or a pool of `just_audio` players) for the actual bell/warning sound effects

---

## 3. audio_service Integration

### pubspec.yaml

```yaml
dependencies:
  audio_service: ^0.18.18
  just_audio: ^0.10.5
```

### Android Setup — AndroidManifest.xml

File: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>

    <application
        android:label="Boxing Timer"
        android:icon="@mipmap/ic_launcher">

        <activity
            android:name="com.ryanheise.audioservice.AudioServiceActivity"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <service
            android:name="com.ryanheise.audioservice.AudioService"
            android:foregroundServiceType="mediaPlayback"
            android:exported="true"
            tools:ignore="ExportedService">
            <intent-filter>
                <action android:name="android.media.browse.MediaBrowserService" />
            </intent-filter>
        </service>

        <receiver
            android:name="com.ryanheise.audioservice.MediaButtonReceiver"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MEDIA_BUTTON"/>
            </intent-filter>
        </receiver>

    </application>
</manifest>
```

**Important**: Add `xmlns:tools="http://schemas.android.com/tools"` to the `<manifest>` tag if using `tools:ignore`.

### iOS Setup — Info.plist

File: `ios/Runner/Info.plist`

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

That is the only iOS change required.

### AudioHandler Implementation

```dart
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class BoxingTimerAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  BoxingTimerAudioHandler() {
    // Forward just_audio playback state to audio_service
    _player.playbackEventStream.listen((event) {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.pause,
          MediaControl.stop,
        ],
        systemActions: const {},
        androidCompactActionIndices: const [0, 1],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ));
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  /// Custom action: play a bell sound
  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'playBell':
        await _player.setAsset('assets/audio/bell_round_end.wav');
        await _player.play();
        break;
      case 'playWarning':
        await _player.setAsset('assets/audio/warning_10s.wav');
        await _player.play();
        break;
    }
  }
}
```

### Initialization in main()

```dart
late AudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  audioHandler = await AudioService.init(
    builder: () => BoxingTimerAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.yourapp.boxing.timer',
      androidNotificationChannelName: 'Boxing Timer',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: false, // CRITICAL: keep service alive during rest
      androidNotificationIcon: 'mipmap/ic_launcher',
    ),
  );

  runApp(const BoxingTimerApp());
}
```

### Updating the Notification

```dart
// Update the notification to show current round info:
audioHandler.mediaItem.add(MediaItem(
  id: 'boxing_timer',
  title: 'Round 3 of 12',
  artist: '1:45 remaining',
  album: 'Boxing Timer',
  duration: const Duration(minutes: 3),
  artUri: Uri.parse('asset:///assets/images/boxing_icon.png'),
));
```

### Resource File (Prevent Icon Stripping)

Create `android/app/src/main/res/raw/keep.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@drawable/*" />
```

---

## 4. Audio Ducking Over Spotify

### Exact Configuration for Ducking

```dart
import 'package:audio_session/audio_session.dart';

Future<void> configureAudioSession() async {
  final session = await AudioSession.instance;

  await session.configure(const AudioSessionConfiguration(
    // --- iOS Configuration ---
    avAudioSessionCategory: AVAudioSessionCategory.playback,
    avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
    avAudioSessionMode: AVAudioSessionMode.defaultMode,
    avAudioSessionRouteSharingPolicy:
        AVAudioSessionRouteSharingPolicy.defaultPolicy,
    avAudioSessionSetActiveOptions:
        AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,

    // --- Android Configuration ---
    androidAudioAttributes: AndroidAudioAttributes(
      contentType: AndroidAudioContentType.sonification,
      flags: AndroidAudioFlags.none,
      usage: AndroidAudioUsage.notification,
    ),
    androidAudioFocusGainType:
        AndroidAudioFocusGainType.gainTransientMayDuck,
    androidWillPauseWhenDucked: false,
  ));
}
```

### Key Parameters Explained

| Parameter | Value | Effect |
|-----------|-------|--------|
| `AVAudioSessionCategoryOptions.duckOthers` | iOS | Lowers Spotify volume instead of pausing it |
| `AndroidAudioFocusGainType.gainTransientMayDuck` | Android | Requests short-term focus, other apps lower volume |
| `androidWillPauseWhenDucked: false` | Android | Our app keeps playing even if another app tries to duck us |
| `notifyOthersOnDeactivation` | iOS | Tells Spotify to restore volume when we deactivate |

### CRITICAL: Restoring Spotify Volume After Bell

Known issue: Spotify stays ducked if you don't deactivate the session. You MUST deactivate after each bell sound:

```dart
Future<void> playBellWithDucking() async {
  final session = await AudioSession.instance;

  // Activate session (this ducks Spotify)
  await session.setActive(true);

  // Play the bell
  await bellPlayer.seek(Duration.zero);
  await bellPlayer.play();

  // Wait for bell to finish
  await bellPlayer.playerStateStream.firstWhere(
    (state) => state.processingState == ProcessingState.completed,
  );

  // Deactivate session (Spotify volume restores)
  await session.setActive(false);
}
```

### Alternative: Mix Without Ducking

If users prefer bell plays OVER music at full volume without any ducking:

```dart
avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransient,
```

This plays your bell at full volume and does not touch Spotify's volume at all. Best for short sounds like a bell.

---

## 5. Audio Focus and Interruptions (Phone Calls)

### Listening for Interruptions

```dart
Future<void> setupInterruptionHandling() async {
  final session = await AudioSession.instance;

  session.interruptionEventStream.listen((event) {
    if (event.begin) {
      // Interruption started
      switch (event.type) {
        case AudioInterruptionType.pause:
          // Phone call or high-priority app — PAUSE timer
          timerController.pauseTimer();
          _wasPlayingBeforeInterruption = true;
          break;
        case AudioInterruptionType.duck:
          // Navigation instruction, notification — lower our volume
          bellPlayer.setVolume(0.3);
          break;
        case AudioInterruptionType.unknown:
          // Unknown interruption — pause to be safe
          timerController.pauseTimer();
          _wasPlayingBeforeInterruption = true;
          break;
      }
    } else {
      // Interruption ended
      switch (event.type) {
        case AudioInterruptionType.pause:
          // Phone call ended — resume if we were playing
          if (_wasPlayingBeforeInterruption) {
            timerController.resumeTimer();
            _wasPlayingBeforeInterruption = false;
          }
          break;
        case AudioInterruptionType.duck:
          // Restore volume
          bellPlayer.setVolume(1.0);
          break;
        case AudioInterruptionType.unknown:
          // Don't auto-resume for unknown interruptions
          break;
      }
    }
  });

  // Also handle headphone disconnect (becoming noisy)
  session.becomingNoisyEventStream.listen((_) {
    // User unplugged headphones — keep timer running but note it
    // In a boxing timer context, probably do nothing (gym speakers)
  });
}
```

### Audio Interruption Types

| Type | Trigger | Boxing Timer Action |
|------|---------|-------------------|
| `pause` | Phone call, Siri, alarm | Pause timer, show "Paused - Phone Call" |
| `duck` | Navigation, notification sound | Lower bell volume temporarily |
| `unknown` | Other app took focus | Pause timer (safe default) |

---

## 6. Silent Audio for Background Keep-Alive

### Why This Is Needed

- **iOS**: The OS monitors whether your app is actually producing audio. If you declare the `audio` background mode but sit idle, iOS will kill you.
- **Android**: Foreground service with notification is sufficient. Silent audio is not needed but does not hurt.

### Implementation

Create a 1-second silent WAV file (or generate silence programmatically):

```dart
class BackgroundKeepAlive {
  final AudioPlayer _silentPlayer = AudioPlayer();

  Future<void> startSilentPlayback() async {
    // Load a 1-second silent audio file
    await _silentPlayer.setAsset('assets/audio/silence_1s.wav');
    await _silentPlayer.setLoopMode(LoopMode.one); // Loop forever
    await _silentPlayer.setVolume(0.0); // Completely silent
    await _silentPlayer.play();
  }

  Future<void> stopSilentPlayback() async {
    await _silentPlayer.stop();
  }

  Future<void> dispose() async {
    await _silentPlayer.dispose();
  }
}
```

### Generate Silent WAV File

Use ffmpeg to create a minimal silence file:

```bash
ffmpeg -f lavfi -i anullsrc=r=44100:cl=mono -t 1 -q:a 9 -acodec pcm_s16le assets/audio/silence_1s.wav
```

This creates a ~88KB mono WAV file of 1 second of silence. With looping, it keeps the audio session permanently active.

### Integration with Timer

```dart
// When timer session starts:
await backgroundKeepAlive.startSilentPlayback();

// When a bell needs to play, the real bell player plays on top
// The silent player keeps the background mode alive during rest periods

// When session ends:
await backgroundKeepAlive.stopSilentPlayback();
```

---

## 7. Volume Override

### flutter_volume_controller (v1.3.4)

```dart
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

// Save current volume, set to max, play bell, restore
Future<void> playBellAtMaxVolume() async {
  final originalVolume = await FlutterVolumeController.getVolume();

  // Set to max without showing system UI
  await FlutterVolumeController.setVolume(1.0, showSystemUI: false);

  // Play bell
  await bellPlayer.play();

  // Wait for bell to finish, then restore
  await Future.delayed(const Duration(seconds: 3));
  await FlutterVolumeController.setVolume(originalVolume ?? 0.5, showSystemUI: false);
}
```

### API Reference

```dart
// Get current volume (0.0 to 1.0)
final volume = await FlutterVolumeController.getVolume();

// Set volume (0.0 to 1.0)
await FlutterVolumeController.setVolume(0.8);

// Set without showing system volume slider
await FlutterVolumeController.setVolume(0.8, showSystemUI: false);

// Mute/unmute
await FlutterVolumeController.setMute(true);
await FlutterVolumeController.setMute(false);

// Listen to hardware volume button changes
FlutterVolumeController.addListener((volume) {
  print('Volume changed to: $volume');
});

// Specify audio stream (Android only)
await FlutterVolumeController.setVolume(
  1.0,
  stream: AudioStream.music,
);
```

### Platform Limitations

| Platform | Limitation |
|----------|-----------|
| **Android** | Only 15 discrete volume steps. Setting 0.73 rounds to nearest step (~0.73). Works on all streams (music, alarm, ring, notification). |
| **iOS** | Must test on real device (simulator does not support volume). Cannot override Do Not Disturb / Silent Mode switch. |
| **Both** | You CANNOT force audio playback if the user has physically muted the device with the hardware switch (iOS) or set volume to 0. You can only set the media volume level. |
| **Both** | Changing system volume without user intent may violate app store guidelines. Provide a setting to enable/disable this. |

### Recommended UX

Do NOT force override volume. Instead:

```dart
// Check if volume is too low and warn the user
Future<void> checkVolumeBeforeSession() async {
  final volume = await FlutterVolumeController.getVolume();
  if (volume != null && volume < 0.3) {
    // Show dialog: "Your volume is low. You may not hear the bell."
    // Offer to set volume to 70%
  }
}
```

---

## 8. Sound Asset Preparation

### Recommended Audio Format

| Format | Use Case | File Size (3s bell) | Decoding | Recommendation |
|--------|----------|-------------------|----------|----------------|
| **WAV 16-bit 44.1kHz mono** | Bell sound effects | ~130 KB | None (instant) | **Best for short SFX** |
| **OGG Vorbis** | Longer audio | ~15 KB | Low CPU | Good alternative |
| **MP3 192kbps** | Longer audio | ~70 KB | Low CPU | Most compatible |
| **M4A/AAC** | Music, seeking | ~50 KB | Low CPU | Best for seeking |

**Use WAV for all bell/warning sounds.** The files are tiny (under 200KB each) and require zero decoding time, giving the lowest possible playback latency.

### Asset List for Boxing Timer

```
assets/audio/
  bell_round_end.wav      # 3-strike boxing bell (end of round)
  bell_round_start.wav    # Single strike (start of round)
  warning_10s.wav         # Double tap / short bell (10s warning)
  warning_30s.wav         # Optional: verbal or different tone
  rest_end.wav            # Bell for rest period ending
  silence_1s.wav          # For background keep-alive loop
```

### Free Sound Sources (with Licenses)

| Source | URL | License | Notes |
|--------|-----|---------|-------|
| **Pixabay** | pixabay.com/sound-effects/search/boxing/ | Royalty-free, no attribution | Best option — cleanest license |
| **Freesound** "Boxing Bell.wav" by Benboncan | freesound.org/people/Benboncan/sounds/66951/ | CC Attribution 3.0 | High quality, requires attribution |
| **Free Sounds Library** | freesoundslibrary.com/boxing-bell/ | CC BY 4.0 | Attribution required |
| **BigSoundBank** | bigsoundbank.com | Royalty-free | WAV and MP3 available |

### Preparing Sound Files

```bash
# Convert to mono 44.1kHz 16-bit WAV (optimal for mobile)
ffmpeg -i raw_bell.mp3 -ac 1 -ar 44100 -sample_fmt s16 bell_round_end.wav

# Trim to exact duration (e.g., 2.5 seconds)
ffmpeg -i bell_round_end.wav -t 2.5 -c copy bell_round_end_trimmed.wav

# Normalize volume to -1dB peak
ffmpeg -i bell_round_end.wav -af "loudnorm=I=-14:TP=-1:LRA=11" bell_normalized.wav

# Create 1-second silence file
ffmpeg -f lavfi -i anullsrc=r=44100:cl=mono -t 1 -acodec pcm_s16le silence_1s.wav
```

### pubspec.yaml Asset Declaration

```yaml
flutter:
  assets:
    - assets/audio/
```

---

## 9. Android 14+ Foreground Service Requirements

### What Changed in Android 14 (API 34)

1. **Foreground service types are REQUIRED.** Every foreground service must declare a `foregroundServiceType` in the manifest. Omitting it throws `MissingForegroundServiceTypeException`.
2. **Type-specific permissions are REQUIRED.** For `mediaPlayback`, you need `FOREGROUND_SERVICE_MEDIA_PLAYBACK` in addition to `FOREGROUND_SERVICE`.
3. **Runtime specification required.** The type must also be specified when calling `startForeground()` at runtime (audio_service handles this).

### Complete Manifest for Android 14+

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <!-- Base permissions -->
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>

    <!-- Android 14+ (API 34) REQUIRED for media playback foreground service -->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>

    <!-- Optional: keep running during Doze mode for precise timer -->
    <uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"/>

    <application
        android:label="Boxing Timer"
        android:icon="@mipmap/ic_launcher">

        <activity
            android:name="com.ryanheise.audioservice.AudioServiceActivity"
            android:launchMode="singleTop"
            android:exported="true"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <!-- audio_service foreground service — MUST have foregroundServiceType -->
        <service
            android:name="com.ryanheise.audioservice.AudioService"
            android:foregroundServiceType="mediaPlayback"
            android:exported="true"
            tools:ignore="ExportedService">
            <intent-filter>
                <action android:name="android.media.browse.MediaBrowserService"/>
            </intent-filter>
        </service>

        <!-- Media button receiver for headset/notification controls -->
        <receiver
            android:name="com.ryanheise.audioservice.MediaButtonReceiver"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MEDIA_BUTTON"/>
            </intent-filter>
        </receiver>

    </application>
</manifest>
```

### build.gradle Target SDK

File: `android/app/build.gradle`

```groovy
android {
    compileSdk = 35  // or 34

    defaultConfig {
        targetSdk = 35   // or 34 — triggers the new requirements
        minSdk = 23      // or 21 for broader device support
    }
}
```

### Google Play Console Declaration

When targeting Android 14+, you must also declare your foreground service types in Google Play Console under **App content > Foreground service permissions**. Select "Media playback" and provide justification (e.g., "Timer app plays boxing bell sounds and maintains session timing while phone is locked").

---

## 10. Complete Integration Architecture

```
┌─────────────────────────────────────────────────┐
│                    main()                        │
│  AudioService.init(BoxingTimerAudioHandler)      │
│  configureAudioSession() — ducking config        │
│  setupInterruptionHandling()                     │
└───────────────┬─────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────┐
│         BoxingTimerAudioHandler                   │
│  extends BaseAudioHandler                         │
│                                                   │
│  ┌─────────────────┐  ┌──────────────────┐       │
│  │  Silent Player   │  │  Bell Player(s)  │       │
│  │  (keep-alive)    │  │  (pool of 2-3)   │       │
│  │  loops silence   │  │  preloaded WAVs  │       │
│  └─────────────────┘  └──────────────────┘       │
│                                                   │
│  playbackState → notification + lock screen       │
│  mediaItem → "Round 3 of 12 — 1:45"             │
│  customAction('playBell') → trigger bell          │
└───────────────┬─────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────┐
│            AudioSession                           │
│  - Duck Spotify during bell                       │
│  - Handle phone call interruptions                │
│  - Restore other apps' volume after bell          │
└─────────────────────────────────────────────────┘
```

### Session Lifecycle

1. **User starts session**: `AudioService.init()` already called. Start silent playback loop. Set `mediaItem` to "Round 1 of 12".
2. **Round running**: Silent player loops. Timer ticks in Dart isolate or periodic timer. Update `mediaItem.artist` with remaining time periodically (every 5-10 seconds, not every second — notification updates are expensive).
3. **10-second warning**: `session.setActive(true)` → play warning WAV → `session.setActive(false)` (Spotify unducks).
4. **Round end bell**: Same pattern. `session.setActive(true)` → play bell → wait → `session.setActive(false)`.
5. **Rest period**: Silent player keeps background alive. Update notification to "Rest — 45s".
6. **Phone call**: `interruptionEventStream` fires `pause` → pause timer, show "Paused".
7. **Phone call ends**: Stream fires end → resume timer.
8. **Session complete**: Stop silent player. Set `processingState` to `completed`. Optionally stop the foreground service.
