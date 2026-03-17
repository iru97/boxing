# Boxing App - Sprint Plan

## Overview

7 sprints to deliver a production-ready boxing training timer app.
Each sprint has clear deliverables, research context, and acceptance criteria.

### Sprint Summary

| Sprint | Name | Focus | Key Deliverable |
|--------|------|-------|-----------------|
| 0 | Foundation | Project setup, architecture, models | Flutter project compiles and runs |
| 1 | Timer Engine | Core timer logic + audio service | Timer runs accurately in foreground |
| 2 | Timer Screen | Active workout UI | Full timer screen with phase colors |
| 3 | Sessions | Session management + persistence | Create, save, load custom sessions |
| 4 | Background & Audio | Background execution + audio ducking | Timer survives backgrounding, audio over music |
| 5 | Polish & UX | Glove-friendly UX, animations, settings | Production-quality UI |
| 6 | Platform & Release | Platform config, testing, release prep | App store ready builds |

---

## Sprint 0: Foundation

**Goal**: Flutter project initialized with architecture, dependencies, data models, theme, and routing. App compiles and shows a placeholder home screen.

### Research Findings

#### Architecture: Feature-First with Riverpod 3.x
- **Feature-first** structure: each feature gets its own folder with screen, controller, state, providers
- **Riverpod 3.x** (stable): Use `@riverpod` annotation with `riverpod_generator` for code-gen providers
- `Notifier` and `AsyncNotifier` replace the deprecated `StateNotifier`
- Provider organization: one provider file per feature, providers co-located with their feature

#### Data Models: Freezed 3.x
- Use `@freezed` for immutable data classes with `copyWith`, equality, and JSON serialization
- Union types for `TimerPhase`: `@freezed sealed class TimerPhase with _$TimerPhase { factory warmup(); factory work(); ... }`
- Duration stored as int (milliseconds) in Hive since Duration isn't natively supported
- `hive_ce` (community edition) recommended over original `hive` - actively maintained, drop-in replacement

#### Routing: go_router
- Lightweight, declarative, official Flutter team package
- Simple for our app (3-4 screens): home, timer, session editor, settings
- Supports deep linking for future use

#### Theme: Material 3
- `useMaterial3: true` in ThemeData
- Custom `ColorScheme.fromSeed()` or manual color scheme
- Phase colors as app-level constants (not theme): work=green, warning=amber, rest=red
- Dark theme primary (gym visibility) with optional light theme

### Deliverables

#### 1. Flutter Project Initialization
```bash
flutter create --org com.boxing --project-name boxing .
```

#### 2. pubspec.yaml Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.3.0
  riverpod_annotation: ^3.3.0
  go_router: ^14.0.0
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0
  hive_ce: ^2.6.0
  hive_ce_flutter: ^2.1.0
  just_audio: ^0.9.42
  audio_service: ^0.18.15
  wakelock_plus: ^4.0.0
  equatable: ^2.0.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.0
  riverpod_generator: ^3.3.0
  freezed: ^3.2.0
  json_serializable: ^6.8.0
  hive_ce_generator: ^1.6.0
```

#### 3. Project Structure
```
lib/
├── main.dart                        # Hive init, ProviderScope, runApp
├── app.dart                         # MaterialApp.router, theme, GoRouter
├── core/
│   ├── constants/
│   │   ├── app_constants.dart       # Durations, limits, defaults
│   │   └── preset_sessions.dart     # 17 built-in session presets
│   ├── theme/
│   │   ├── app_theme.dart           # Material 3 ThemeData (dark + light)
│   │   ├── app_colors.dart          # Phase colors, brand colors
│   │   └── app_typography.dart      # Timer display font, body text
│   └── router/
│       └── app_router.dart          # GoRouter configuration
├── models/
│   ├── session.dart                 # @freezed Session model
│   ├── timer_state.dart             # @freezed TimerState model
│   └── timer_phase.dart             # @freezed sealed union TimerPhase
├── services/
│   ├── timer_engine.dart            # (stub) Core timer logic
│   ├── audio_service.dart           # (stub) Sound playback
│   ├── storage_service.dart         # Hive initialization and access
│   └── wakelock_service.dart        # (stub) Screen wake lock
├── features/
│   ├── home/
│   │   └── home_screen.dart         # Session list / launcher
│   ├── timer/
│   │   └── timer_screen.dart        # (placeholder) Active timer
│   ├── session/
│   │   └── session_editor_screen.dart # (placeholder) Session config
│   └── settings/
│       └── settings_screen.dart     # (placeholder) App settings
└── widgets/                         # (empty, ready for shared widgets)
```

#### 4. Data Models (Full Implementation)

**Session Model**:
```
Session:
  - id: String (UUID)
  - name: String
  - rounds: int (1-30)
  - roundDuration: Duration (15s-10min)
  - restDuration: Duration (0s-5min)
  - warningTime: Duration (0s, 5s, 10s, 15s, 30s)
  - warmupDuration: Duration (0s, 5s, 10s, 15s, 30s)
  - soundPack: String (default: 'classic_bell')
  - autoAdvance: bool (default: true)
  - keepScreenOn: bool (default: true)
  - voiceAnnounce: bool (default: false)
  - volumeOverride: bool (default: false)
  - isPreset: bool
  - roundOverrides: List<RoundOverride>? (optional per-round durations)
```

**TimerState Model**:
```
TimerState:
  - phase: TimerPhase (warmup | work | rest | paused | complete)
  - currentRound: int
  - totalRounds: int
  - timeRemaining: Duration (in current phase)
  - totalElapsed: Duration
  - isWarning: bool (true when within warning time)
  - isPaused: bool
  - sessionName: String
```

**TimerPhase Enum**:
```
TimerPhase: warmup | work | rest | complete
```

#### 5. Preset Sessions
All 17 presets from VISION.md implemented as const list.

#### 6. Theme
- Dark theme primary (black background, white timer text)
- Phase colors: work=#4CAF50, warning=#FF9800, rest=#F44336
- Timer font: monospace, 72sp minimum for main countdown
- Material 3 enabled

### Acceptance Criteria
- [ ] `flutter analyze` passes with zero errors
- [ ] `flutter test` runs (even if no tests yet)
- [ ] App launches and shows home screen with preset session list
- [ ] Tapping a session navigates to timer screen (placeholder)
- [ ] Models generate correctly with `dart run build_runner build`
- [ ] Hive initializes on app start

---

## Sprint 1: Timer Engine

**Goal**: Core timer engine that accurately counts rounds, fires phase transitions, and plays audio cues. Works in the foreground only (background comes in Sprint 4).

### Research Findings

#### Timer Accuracy Pattern
- `Timer.periodic(Duration(milliseconds: 100), callback)` for UI ticks
- Actual timing: store `_phaseStartTime = DateTime.now()` and compute elapsed as `DateTime.now().difference(_phaseStartTime)`
- On each tick: check if elapsed >= phase duration, if so trigger transition
- On `AppLifecycleState.resumed`: recalculate from DateTime, don't rely on tick count
- Warning check: if `phaseRemaining <= warningDuration`, set `isWarning = true`

#### State Machine
```
[initial] → warmup → work → (warning sub-state) → rest → work → ... → complete
                         ↑                              |
                         └──────────────────────────────┘
Pause can happen from any active state, resume returns to same state.
Skip forward: jump to next phase. Skip back: restart current round.
```

#### Timer Engine API
```dart
class TimerEngine {
  Stream<TimerState> get stateStream;
  void start(Session session);
  void pause();
  void resume();
  void stop();
  void skipForward();  // next round or next phase
  void skipBack();     // restart current round
  void dispose();
}
```

#### Audio Cue Triggers
- `onPhaseChange(work)` → play round start bell
- `onWarning()` → play warning clapper (10s before round end)
- `onPhaseChange(rest)` → play round end bell
- `onPhaseChange(complete)` → play session complete bell
- `onRoundAnnounce()` → TTS "Round N" (Phase 2+, stub for now)

### Deliverables

#### 1. TimerEngine Service
- Pure Dart class, no Flutter/widget dependencies
- DateTime-based elapsed time tracking
- StreamController<TimerState> for state emission
- Full state machine: warmup → work → rest → ... → complete
- Pause/resume with DateTime re-sync
- Skip forward/back

#### 2. Audio Service (Basic)
- Load sound assets from `assets/sounds/`
- Play single bell (round start), double bell (warning), triple bell (round end)
- Pre-load all sounds on session start
- Simple `just_audio` AudioPlayer usage (no background service yet)

#### 3. Sound Assets
- Source or create 4 audio files:
  - `bell_single.wav` - Round start
  - `bell_warning.wav` - 10-second warning (clapper/double tap)
  - `bell_triple.wav` - Round end
  - `bell_long.wav` - Session complete
- WAV format, <500KB each

#### 4. Timer Provider (Riverpod)
- `timerEngineProvider` - Singleton TimerEngine instance
- `timerStateProvider` - StreamProvider from engine's stateStream
- `activeSessionProvider` - The currently loaded session
- `audioServiceProvider` - Audio playback service

#### 5. Unit Tests
- Timer accuracy: verify phase transitions within ±100ms using fakeAsync
- Phase order: warmup → work → rest → work → rest → complete
- Warning triggers at correct time
- Pause preserves remaining time
- Skip forward/back works correctly
- Round count matches session config

### Acceptance Criteria
- [ ] Timer counts down accurately (verified by unit tests)
- [ ] Phase transitions fire at correct moments
- [ ] Warning triggers at configured time before round end
- [ ] Bell sounds play for each phase transition
- [ ] Pause/resume works without time drift
- [ ] Skip forward/back works
- [ ] All 17 presets can be loaded and run
- [ ] 90%+ unit test coverage on timer engine

---

## Sprint 2: Timer Screen

**Goal**: Full timer UI with large countdown display, phase colors, round indicator, and basic controls. Visible and usable during a real workout.

### Research Findings

#### Large Timer Display
- `CustomPaint` with `TextPainter` for maximum control over text rendering
- Or: simple `Text` widget with monospace font at 72-96sp, using `AnimatedBuilder` to avoid full tree rebuilds
- Key: only rebuild the text widget on tick, not the entire screen
- Use `RepaintBoundary` around the timer text to isolate repaints

#### Circular Progress Ring
- `CustomPainter` drawing an arc with `canvas.drawArc()`
- Sweep angle = `(timeRemaining / totalPhaseDuration) * 2π`
- Animate smoothly with `AnimationController` or direct repaint on timer tick
- `percent_indicator` package is an option but CustomPainter gives more control
- Line width 8-12dp, rounded caps, phase-colored

#### Color Transitions
- `ColorTween` + `AnimatedContainer` for smooth background/accent transitions
- Or: immediate color switch (more "boxing gym" feel - the gym clock doesn't fade)
- Decision: immediate switch with a brief flash effect at transitions

#### Layout
```
┌─────────────────────────────┐
│         ROUND 3 / 8         │  ← Round indicator (24sp)
│                             │
│    ┌───────────────────┐    │
│    │                   │    │
│    │      2:47         │    │  ← Main countdown (72-96sp, monospace)
│    │                   │    │
│    │   ╭─────────╮     │    │  ← Circular progress ring
│    │   │         │     │    │
│    └───────────────────┘    │
│                             │
│         WORK               │  ← Phase label (32sp)
│                             │
│   ┌───┐    ┌───┐    ┌───┐  │
│   │ ◀ │    │ ⏸ │    │ ▶ │  │  ← Controls (64dp+ touch targets)
│   └───┘    └───┘    └───┘  │
│                             │
│    Total: 12:33 elapsed     │  ← Total elapsed (16sp, subtle)
└─────────────────────────────┘
```

#### Glove-Friendly Controls
- Pause/resume: center button, 80dp minimum
- Skip forward/back: side buttons, 64dp minimum
- Tap anywhere on timer area could also pause (optional, configurable)
- No swipe gestures during active timer

### Deliverables

#### 1. Timer Screen
- Full-screen dark background
- Large monospace countdown (72-96sp)
- Round indicator "Round X / Y"
- Phase label (WARMUP, WORK, REST, COMPLETE)
- Total elapsed time (subtle, bottom)
- Immediate color changes for phase transitions

#### 2. Circular Progress Widget
- CustomPainter-based progress ring
- Depletes clockwise as time runs down
- Color matches current phase
- Smooth animation synced to timer ticks

#### 3. Timer Controls
- Pause/Resume button (80dp, center)
- Skip Forward button (64dp, right)
- Skip Back button (64dp, left)
- Stop/Exit button (corner, with confirmation dialog)
- All with haptic feedback on tap

#### 4. Phase Color System
- Background tint + progress ring + phase label all color-coordinated
- Work: green tones
- Warning: amber/orange tones
- Rest: red tones
- Warmup: blue tones
- Complete: neutral/white

#### 5. Session Start Flow
- Home screen → tap session → confirmation (show session summary) → start
- Pre-load audio during confirmation screen
- Warmup countdown if configured

#### 6. Widget Tests
- Timer display shows correct format (M:SS or MM:SS)
- Phase colors match current phase
- Controls respond to taps
- Round indicator shows correct values

### Acceptance Criteria
- [ ] Timer screen displays countdown accurately
- [ ] Phase colors change immediately on transitions
- [ ] Progress ring animates smoothly
- [ ] Controls work (pause, resume, skip, stop)
- [ ] Display readable from 2+ meters (large text, high contrast)
- [ ] Touch targets are all >= 64dp
- [ ] Landscape orientation supported
- [ ] No jank or frame drops during timer animation

---

## Sprint 3: Sessions

**Goal**: Full session management - create, edit, save, delete, and load custom sessions. Presets are always available. Data persists across app restarts.

### Research Findings

#### Hive CE for Persistence
- `hive_ce` is the actively maintained fork of Hive
- Store Duration as int milliseconds (Hive doesn't support Duration natively)
- Custom TypeAdapter or JSON-based storage via `hive_ce` box
- Pattern: `Box<Map<String, dynamic>>` with JSON serialization, or custom TypeAdapter with `@HiveType`
- Initialize Hive in `main()` before `runApp()`, register adapters

#### Session Repository Pattern
```
StorageService (Hive)
  → SessionRepository (CRUD operations, handles serialization)
    → SessionListNotifier (Riverpod, manages state)
      → UI (session list, editor)
```

#### Session Editor UX
- Form-based editor with sensible defaults
- Sliders for duration values (more intuitive than text input)
- Stepper for round count
- Sound preview (play sample when selecting sound pack)
- "Save as new" and "Update existing" options
- Duplicate preset to create custom variant

### Deliverables

#### 1. Storage Service
- Hive CE initialization in main.dart
- SessionRepository with CRUD: getAll, getById, save, delete
- JSON serialization for Session model
- Separate boxes for presets (read-only) and custom sessions

#### 2. Session Providers
- `sessionListProvider` - All sessions (presets + custom)
- `customSessionsProvider` - User-created sessions only
- `sessionByIdProvider(id)` - Single session lookup
- `sessionFormProvider` - Editor state for create/edit

#### 3. Session List Screen (Home)
- Two sections: "Quick Start" (presets) and "My Sessions" (custom)
- Card-based layout with session name, round summary, total duration
- Tap to start, long-press for edit/delete/duplicate
- FAB to create new session
- Search/filter (optional)

#### 4. Session Editor Screen
- Name field
- Round count (stepper: 1-30)
- Round duration (slider: 15s-10min, with common presets as chips)
- Rest duration (slider: 0s-5min)
- Warning time (chips: off, 5s, 10s, 15s, 30s)
- Warmup countdown (chips: off, 5s, 10s, 15s, 30s)
- Sound pack selector (with preview play)
- Auto-advance toggle
- Keep screen on toggle
- Session summary at bottom (total duration, total rounds)
- Save button

#### 5. Per-Round Overrides (Advanced)
- Toggle "Custom round durations"
- When enabled: show list of rounds with individual duration pickers
- Default: all rounds use session default
- Override: specific rounds can have different durations

#### 6. Tests
- SessionRepository CRUD operations
- Session serialization/deserialization roundtrip
- Session validation (min/max values)
- Session editor form state management
- Preset sessions are immutable and always available

### Acceptance Criteria
- [ ] Custom sessions persist across app restart
- [ ] All 17 presets always available, cannot be deleted
- [ ] Create, edit, duplicate, and delete custom sessions
- [ ] Session editor validates all field constraints
- [ ] Per-round override UI works
- [ ] Total duration preview is accurate
- [ ] Sound pack preview plays correctly

---

## Sprint 4: Background & Audio

**Goal**: Timer runs reliably when app is backgrounded, screen is locked, or user switches to Spotify. Audio cues play over other apps' music. This is the CRITICAL sprint - it solves the #1 user complaint in every competing app.

### Research Findings

#### Foreground Service via audio_service
- `audio_service` wraps your audio logic in an Android foreground service + iOS background audio mode
- Create a custom `AudioHandler` that manages both sound effects AND the silent keep-alive track
- Notification shows: current round, time remaining, play/pause/stop controls
- Android manifest: `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, `WAKE_LOCK`
- iOS Info.plist: `UIBackgroundModes: [audio]`

#### Silent Audio Keep-Alive
- During rest periods (and when timer is active but no sound is playing), loop a silent audio file
- This prevents Android/iOS from suspending the process
- Use a 1-second silent WAV file on infinite loop
- Stop the silent track only when session ends

#### Audio Ducking Configuration
```dart
final session = await AudioSession.instance;
await session.configure(AudioSessionConfiguration(
  avAudioSessionCategory: AVAudioSessionCategory.playback,
  avAudioSessionMode: AVAudioSessionMode.defaultMode,
  avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
  androidAudioAttributes: const AndroidAudioAttributes(
    contentType: AndroidAudioContentType.sonification,
    usage: AndroidAudioUsage.notification,  // or alarm for max priority
  ),
  androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
));
```
- `gainTransientMayDuck` tells other apps to lower volume (duck) when our sound plays
- `contentType: sonification` and `usage: notification` ensures high priority

#### Volume Override
- Android: `volume_controller` package can set system alarm volume
- iOS: Limited - can use `AVAudioSession` to set preferred volume but can't override hardware
- Compromise: Set audio to use alarm stream (Android) which is independent of media volume
- User warning: "Volume override uses alarm volume channel"

#### WidgetsBindingObserver Integration
```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.paused:
      _lastPausedAt = DateTime.now();
      _ensureSilentAudioPlaying();
      break;
    case AppLifecycleState.resumed:
      _resyncTimerFromWallClock();
      break;
    case AppLifecycleState.inactive:
      // Phone call or system dialog - may want to auto-pause
      break;
    case AppLifecycleState.detached:
      // App being killed - save state to Hive for recovery
      _saveTimerCheckpoint();
      break;
  }
}
```

#### Samsung/Huawei/Xiaomi Battery Optimization
- These manufacturers aggressively kill background processes
- Show a one-time dialog asking user to disable battery optimization for the app
- Use `optimization_battery` or `disable_battery_optimization` package
- Link directly to device battery settings

### Deliverables

#### 1. AudioHandler Implementation
- Custom AudioHandler extending BaseAudioHandler
- Manages just_audio player for bell sounds
- Manages silent audio loop for keep-alive
- Exposes media controls (play/pause/stop) in notification
- Updates notification with current round and time

#### 2. Foreground Service Integration
- Android: manifest permissions and service declaration
- iOS: background audio mode configuration
- Notification channel setup
- Real-time notification updates (round X/Y, MM:SS remaining)

#### 3. Silent Audio Keep-Alive
- 1-second silent WAV asset
- Loops continuously during active session
- Stops when session completes
- Prevents OS from killing the process

#### 4. Audio Ducking
- AudioSession configuration for ducking other apps
- Bell sounds briefly lower Spotify volume, then it returns
- Test with Spotify, Apple Music, YouTube Music

#### 5. Lifecycle Management
- WidgetsBindingObserver on timer screen
- Re-sync timer on resume from background
- Save checkpoint on detach (for crash recovery)
- Auto-pause option on phone call (configurable)

#### 6. Wake Lock Integration
- Enable wakelock_plus on session start
- Disable on session complete or stop
- Handle edge case: session paused for >5min → release wake lock

#### 7. Battery Optimization Dialog
- Detect if battery optimization is enabled for our app
- Show one-time dialog explaining why to disable it
- Deep link to device battery settings

#### 8. Integration Tests
- Timer accuracy after 30s in background
- Audio plays with screen locked
- Bell audible while Spotify is playing
- Notification shows correct round/time
- Timer survives app switch and return
- Wake lock engages and releases correctly

### Acceptance Criteria
- [ ] Timer continues accurately with screen locked (verified on real device)
- [ ] Timer continues accurately after switching to Spotify and back
- [ ] Bell sounds play over Spotify without stopping music
- [ ] Notification shows current round and time, updates live
- [ ] Notification controls (pause/resume/stop) work
- [ ] Silent audio prevents process killing during rest periods
- [ ] Wake lock keeps screen on during active session
- [ ] Wake lock releases when session ends
- [ ] Battery optimization dialog shows on first run
- [ ] Timer state recovers after crash (checkpoint restore)

---

## Sprint 5: Polish & UX

**Goal**: Production-quality user experience - animations, haptic feedback, sound packs, settings screen, onboarding, and glove-friendly refinements.

### Research Findings

#### Haptic Feedback
- `HapticFeedback.heavyImpact()` for round start/end
- `HapticFeedback.mediumImpact()` for warning
- `HapticFeedback.selectionClick()` for button presses
- Custom vibration patterns via `vibration` package for distinct events

#### Animations
- Phase transitions: `AnimatedContainer` with 200ms duration for background color
- Round change: brief scale animation on round counter
- Timer text: no animation (must be instantly readable)
- Session start: countdown overlay with number animation (3, 2, 1, GO)

#### Settings Screen
- Default sound pack selection
- Volume override toggle + explanation
- Default warmup duration
- Default warning time
- Keep screen on default
- Auto-advance default
- Theme (dark/light/system)
- Battery optimization shortcut
- About / version info

#### Onboarding
- First launch: brief tutorial (3 screens max)
- "Start your first workout" CTA pointing to preset sessions
- Skip option

### Deliverables

#### 1. Sound Packs
- Classic Bell (default): authentic boxing gym bell
- Digital Buzzer: modern electronic sounds
- Minimal Beep: simple, quiet tones
- Each pack: 4 sounds (start, warning, end, complete)
- Preview in settings and session editor

#### 2. Haptic Feedback System
- Distinct patterns for each event type
- Configurable on/off in settings
- Works alongside audio cues

#### 3. Settings Screen
- Full settings with all options from VISION.md
- Stored in Hive, loaded via Riverpod provider
- Changes apply immediately

#### 4. Animation Polish
- Resume countdown overlay (3-2-1-GO after pause)
- Session start countdown
- Phase transition flash effect
- Round change animation
- Session complete celebration screen

#### 5. Glove-Friendly Refinements
- Tap anywhere on screen to pause/resume (optional, in settings)
- Increase all touch targets to 80dp during active timer
- Remove any swipe gestures from timer screen
- Test with actual boxing gloves

#### 6. Empty States & Error Handling
- Empty custom session list: "Create your first session" prompt
- Audio load failure: fallback to system sounds
- Storage error: graceful degradation with in-memory fallback
- No crash states - always recoverable

#### 7. App Icon & Splash Screen
- Boxing-themed app icon
- Splash screen with app name

### Acceptance Criteria
- [ ] All 3 sound packs work and preview correctly
- [ ] Haptic feedback fires for all events
- [ ] Settings persist and apply immediately
- [ ] Resume countdown shows 3-2-1 after pause
- [ ] Session complete screen shows summary
- [ ] No crashes or unhandled errors in normal usage
- [ ] App icon and splash screen display correctly

---

## Sprint 6: Platform & Release

**Goal**: Platform-specific configuration, comprehensive testing, performance optimization, and app store preparation.

### Research Findings

#### Android Release Checklist
- `minSdkVersion: 24` (Android 7.0+, covers 97%+ of devices)
- `targetSdkVersion: 34` (current Play Store requirement)
- ProGuard/R8 rules for just_audio and audio_service
- Signing key generation and keystore management
- App bundle (AAB) for Play Store, APK for side-loading
- Play Store listing: screenshots, description, privacy policy

#### iOS Release Checklist
- Deployment target: iOS 14.0+
- Background mode capability: audio
- No special entitlements needed (no HealthKit, no push yet)
- App Store Connect: screenshots (6.7", 6.5", 5.5"), description, privacy URL
- Review guidelines: timer apps generally sail through

#### Performance
- Profile with DevTools: check for jank during timer animations
- Ensure <16ms frame times (60fps)
- Memory profiling: no leaks from stream subscriptions or timers
- Battery profiling: measure drain during 30-min session

#### Testing Matrix
- Android: Pixel (stock), Samsung (battery optimization), budget device
- iOS: iPhone (recent), iPhone (older, iOS 14)
- Scenarios: foreground, background, screen locked, music playing, phone call, low battery

### Deliverables

#### 1. Android Configuration
- Manifest: all permissions, foreground service type, service declarations
- Build config: signing, minSdk, targetSdk, ProGuard rules
- Gradle: kotlin version, AGP version compatibility
- Battery optimization detection and dialog

#### 2. iOS Configuration
- Info.plist: background modes, audio session
- Xcode: capabilities, deployment target
- Podfile: minimum iOS version

#### 3. Comprehensive Testing
- Full integration test suite on real devices
- Timer accuracy over 30-minute sessions
- Background survival on Samsung, Pixel, iPhone
- Audio ducking with Spotify, Apple Music, YouTube Music
- Battery drain measurement
- Memory leak detection

#### 4. Performance Optimization
- Profile and fix any jank
- Optimize timer rebuild frequency
- Minimize memory allocations during timer ticks
- Lazy-load non-essential screens

#### 5. App Store Preparation
- App icon (all required sizes)
- Screenshots for both platforms
- App description
- Privacy policy (no data collection for MVP)
- Version numbering: 1.0.0

#### 6. CI/CD Setup (Optional)
- GitHub Actions for flutter analyze + flutter test
- Build APK/IPA on push to main

### Acceptance Criteria
- [ ] `flutter build apk --release` succeeds
- [ ] `flutter build ios --release` succeeds (or --no-codesign)
- [ ] All tests pass on real Android device
- [ ] All tests pass on real iOS device
- [ ] Timer accurate over 30-minute session on both platforms
- [ ] Background survival on Samsung (aggressive battery optimization)
- [ ] No memory leaks detected after 30-minute session
- [ ] 60fps maintained during timer animations
- [ ] App store screenshots and metadata ready

---

## Sprint Dependency Graph

```
Sprint 0 (Foundation)
    │
    ▼
Sprint 1 (Timer Engine)
    │
    ├──────────────┐
    ▼              ▼
Sprint 2       Sprint 3
(Timer UI)     (Sessions)
    │              │
    └──────┬───────┘
           ▼
    Sprint 4 (Background & Audio)
           │
           ▼
    Sprint 5 (Polish & UX)
           │
           ▼
    Sprint 6 (Platform & Release)
```

**Note**: Sprints 2 and 3 can run in parallel since they have no dependencies on each other - only on Sprint 1.

---

## Risk Register

| Risk | Impact | Mitigation |
|------|--------|------------|
| Timer drift when backgrounded | Critical | DateTime-based timing, wall-clock re-sync, integration tests on real devices |
| Audio not playing over music | Critical | Audio ducking config, alarm audio usage, extensive testing with Spotify |
| Samsung kills background process | High | Foreground service, silent audio, battery optimization dialog |
| just_audio latency >200ms | High | Pre-load all assets, use AudioPlayer pool, test on budget devices |
| Hive data migration issues | Medium | Version stamped storage, migration logic from day 1 |
| iOS background audio rejection | Medium | Follow Apple guidelines exactly, use proper audio session category |
| Large APK size from audio assets | Low | Compress audio to OGG, keep under 2MB total for sound packs |
