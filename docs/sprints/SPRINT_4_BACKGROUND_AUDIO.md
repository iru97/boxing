# Sprint 4: Background & Audio

## Objective
Make the timer survive app backgrounding, screen lock, and music apps. Audio cues play over Spotify/Apple Music. This sprint solves the #1 user complaint in every competing boxing timer app.

## THIS IS THE CRITICAL SPRINT. Everything else is worthless if this fails.

## Tasks

### Task 4.1: Custom AudioHandler
- Extend `BaseAudioHandler` from audio_service package
- Manages two audio players:
  1. **Bell player**: plays sound effects (round start, warning, round end)
  2. **Silent player**: loops silent audio to keep process alive
- Implements media controls:
  - play() → resume timer
  - pause() → pause timer
  - stop() → end session
  - customAction('skipForward') → skip round
  - customAction('skipBack') → restart round
- **Agent**: flutter-specialist

### Task 4.2: Foreground Service Notification
- Android notification with:
  - Title: "Boxing Timer - Round 3/8"
  - Subtitle: "2:47 remaining - WORK"
  - Actions: Pause/Resume, Stop
  - Ongoing (cannot be dismissed)
  - Low-priority sound (no notification sound, we play our own)
- Update notification on every timer tick (throttle to 1/sec)
- Remove notification when session ends
- **Agent**: flutter-specialist + platform-integrator

### Task 4.3: Android Manifest Configuration
- Permissions:
  ```xml
  <uses-permission android:name="android.permission.WAKE_LOCK"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>
  ```
- Service declaration:
  ```xml
  <service android:name="com.ryanheise.audioservice.AudioService"
    android:foregroundServiceType="mediaPlayback"
    android:exported="false"/>
  ```
- Notification channel in Application class
- **Agent**: platform-integrator

### Task 4.4: iOS Configuration
- Info.plist:
  ```xml
  <key>UIBackgroundModes</key>
  <array>
    <string>audio</string>
  </array>
  ```
- Audio session category: playback
- Audio session mode: default
- Audio session options: mixWithOthers, duckOthers
- **Agent**: platform-integrator

### Task 4.5: Silent Audio Keep-Alive
- Create `assets/sounds/silence.wav` (1 second of silence, ~44KB)
- Loop this file continuously during active sessions
- Start on session start, stop on session end
- This prevents Android/iOS from suspending the process
- Must continue during rest periods when no bells are ringing
- **Agent**: flutter-specialist

### Task 4.6: Audio Ducking Configuration
- Configure AudioSession for ducking:
  - `gainTransientMayDuck` - other apps lower volume during our sounds
  - `contentType: sonification` - our sounds are alerts, not music
  - `usage: alarm` or `notification` - high priority audio stream
- Test scenarios:
  - Bell sound while Spotify is playing
  - Bell sound while Apple Music is playing
  - Bell sound while YouTube is playing
- **Agent**: flutter-specialist

### Task 4.7: Volume Override
- When enabled: play bell sounds on alarm audio stream (Android)
- Alarm stream volume is independent of media volume
- User can set alarm volume high even when media volume is low
- iOS limitation: can set preferred volume but can't force it
- Show explanation to user: "Uses alarm volume channel for louder alerts"
- **Agent**: flutter-specialist

### Task 4.8: Lifecycle Management
- Implement `WidgetsBindingObserver` in timer screen:
  - `paused`: record timestamp, ensure silent audio playing
  - `resumed`: re-sync timer from DateTime, update UI
  - `inactive`: possible phone call - optionally auto-pause
  - `detached`: save timer checkpoint to Hive (crash recovery)
- Timer engine re-sync on resume:
  1. Calculate actual elapsed since last known timestamp
  2. Fast-forward through any missed phase transitions
  3. Update current phase, round, and remaining time
  4. Emit corrected state to UI
- **Agent**: flutter-specialist

### Task 4.9: Timer Checkpoint & Recovery
- Save timer state to Hive every 10 seconds during active session:
  - Session ID, current round, phase, timestamps
- On app restart: check for active checkpoint
  - If found and session was < 30min ago: offer to resume
  - If stale: discard checkpoint
- **Agent**: state-manager

### Task 4.10: Wake Lock Integration
- Enable `WakelockPlus.enable()` on session start
- Disable `WakelockPlus.disable()` on session end/stop
- Also disable if session paused for > 5 minutes
- Re-enable on resume from long pause
- **Agent**: flutter-specialist

### Task 4.11: Battery Optimization Dialog
- On first run: check if battery optimization is enabled
- If yes: show dialog explaining why to disable it
  - "For reliable round timing, please disable battery optimization for Boxing"
  - "Some phones (Samsung, Huawei, Xiaomi) may stop the timer in the background"
- Button: "Open Settings" → deep link to battery optimization page
- Button: "Not now" → dismiss, show again after 3 sessions
- Store preference in Hive
- **Agent**: widget-builder + platform-integrator

### Task 4.12: Integration Tests
- Test on real Android device:
  - [ ] Timer accurate after 30s background
  - [ ] Timer accurate after 2min background
  - [ ] Bell plays with screen locked
  - [ ] Bell audible while Spotify plays
  - [ ] Notification shows and updates
  - [ ] Notification controls work
  - [ ] Timer survives app switch (Recent Apps → other app → back)
- Test on real iOS device:
  - [ ] Timer accurate after 30s background
  - [ ] Bell plays with screen locked
  - [ ] Bell audible while Apple Music plays
- Test edge cases:
  - [ ] Phone call during session (pause and resume)
  - [ ] Alarm fires during session
  - [ ] Low battery mode
  - [ ] Samsung "sleeping apps" optimization
- **Agent**: test-writer

## Definition of Done
- [ ] Timer accurate after 2 minutes in background on Android AND iOS
- [ ] Timer accurate after screen lock on both platforms
- [ ] Bell sounds play over Spotify without stopping music
- [ ] Notification shows current round and time, updates live
- [ ] Notification pause/resume/stop controls work
- [ ] Silent audio prevents process killing on both platforms
- [ ] Wake lock keeps screen on during session
- [ ] Timer checkpoint saves and recovery offer works
- [ ] Battery optimization dialog shows on first run
- [ ] All integration tests pass on real devices

## Risk Mitigation
- If audio_service doesn't work reliably: fall back to flutter_foreground_task
- If audio ducking doesn't work with specific music apps: document limitations
- If Samsung kills the app despite foreground service: add step-by-step guide for user
