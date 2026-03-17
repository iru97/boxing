# Boxing — Training Timer App

A **boxing-first** training timer for Android and iOS. Built with Flutter.

Solves the #1 complaint across every competing app: **the timer dies in the background**. Boxing keeps running through screen lock, Spotify, and Android battery optimization.

---

## Features

- **17 built-in presets** — Pro Boxing, Amateur, Heavy Bag, Tabata, MMA, Muay Thai, and more
- **Custom sessions** — create, edit, duplicate, delete with full persistence
- **Reliable background timer** — foreground service + silent audio keep-alive
- **Audio ducking** — bell sounds play over your music without stopping it
- **Wake lock** — screen stays on during your workout
- **Phase colors** — green (WORK), amber (WARNING), red (REST)
- **Warning cue** — configurable bell X seconds before round ends
- **Warmup countdown** — optional countdown before round 1
- **Skip controls** — skip forward/back between phases; disabled while paused
- **Settings** — default warning, warmup, sound pack, theme, haptic feedback
- **Dark/Light/System theme** — Material 3

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.7.2` ([install](https://docs.flutter.dev/get-started/install))
- Android SDK (API 24+) or Xcode 14+ for iOS
- A physical device for background/audio testing (emulators have limited audio)

### Install & Run

```bash
# Get dependencies
flutter pub get

# Run on connected device (debug)
export PATH="/opt/flutter/bin:$PATH"
flutter run

# Run tests
flutter test

# Analyze
flutter analyze
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires Xcode + Apple Developer account)
flutter build ios --release
```

---

## Project Structure

```
lib/
├── main.dart                        # Hive init, audio_service init, ProviderScope
├── app/
│   ├── app.dart                     # MaterialApp.router, theme switching
│   └── router.dart                  # GoRouter — 5 routes
├── core/
│   ├── constants/
│   │   ├── app_constants.dart       # Limits, defaults, option lists
│   │   └── preset_sessions.dart     # 17 built-in presets (immutable)
│   ├── theme/
│   │   ├── app_theme.dart           # Material 3 light + dark ThemeData
│   │   ├── app_colors.dart          # Brand palette
│   │   └── timer_colors.dart        # Phase colors (work/warning/rest/warmup)
│   └── utils/
│       └── duration_formatter.dart  # Duration → "M:SS" / "MM:SS"
├── features/
│   ├── timer/
│   │   ├── domain/
│   │   │   ├── timer_engine.dart    # Core engine: DateTime-anchored, pure Dart
│   │   │   └── timer_state.dart     # Freezed sealed union: idle|warmup|work|rest|paused|complete
│   │   ├── data/
│   │   │   └── timer_lifecycle_service.dart  # Wake lock, keep-alive, notifications
│   │   └── presentation/
│   │       ├── timer_screen.dart    # Session summary + active timer + complete screen
│   │       ├── timer_controller.dart # Riverpod providers
│   │       └── widgets/             # CountdownDisplay, ProgressRing, TimerControls, …
│   ├── sessions/
│   │   ├── domain/session_model.dart         # Freezed SessionModel (Duration as int seconds)
│   │   ├── data/session_repository.dart      # Hive CRUD (JSON strings, no TypeAdapters)
│   │   └── presentation/
│   │       ├── session_list_screen.dart       # Home: presets + custom sessions
│   │       ├── session_editor_screen.dart     # Create / edit / customize preset
│   │       └── sessions_controller.dart       # Riverpod providers + controller
│   ├── audio/
│   │   └── data/
│   │       ├── boxing_audio_handler.dart      # AudioHandler: bells + silent keep-alive
│   │       └── audio_player_service.dart      # Facade: handler mode or fallback player
│   └── settings/
│       ├── domain/app_settings.dart           # Freezed AppSettings
│       ├── data/settings_repository.dart      # Hive persistence
│       └── presentation/
│           ├── settings_screen.dart           # Full settings UI
│           └── settings_controller.dart       # StateNotifier + provider
└── test/
    ├── timer_engine_test.dart                 # 23 unit tests (state machine, accuracy, audio)
    ├── timer_screen_test.dart                 # 19 widget tests (display, controls, colors)
    └── session_repository_test.dart           # 18 integration tests (CRUD, presets, serialize)
```

---

## Architecture

### Timer Engine

The core timer uses **DateTime anchoring** — not tick counting — to prevent drift:

```dart
// On each 50ms tick:
final elapsed = DateTime.now().difference(_phaseStartTime!);
final remaining = _phaseDuration - elapsed;
if (remaining <= Duration.zero) _onPhaseComplete();
```

This means the timer self-corrects every tick and cannot drift, even after backgrounding.

**State machine:**
```
idle → warmup → work ⟶ rest ⟶ work ⟶ rest ⟶ … ⟶ complete
                  ↑                ↓
                  └── (pause/resume can occur at any active state)
```

### Background Execution

```
BoxingAudioHandler (audio_service)
  ├── _bellPlayer     — plays bell sounds on phase transitions
  └── _silentPlayer   — loops silence.wav to keep foreground service alive

TimerLifecycleService
  ├── onSessionStart() — enables WakelockPlus, starts silent audio, registers observer
  └── onSessionEnd()  — releases wake lock, stops silent audio, clears notification
```

Android foreground service is declared via `audio_service` — no manual service needed.

### State Management

- **Riverpod 2.6** with `Provider` and `StateNotifierProvider`
- `timerEngineProvider` — singleton `TimerEngine`, disposed on provider scope close
- `timerStateProvider` — `StreamProvider` wrapping `engine.stateStream`
- `appSettingsProvider` — `StateNotifierProvider<AppSettingsNotifier, AppSettings>`
- `audioServiceProvider` — overridden in `main.dart` with pre-initialized instance

### Data Persistence

- **Hive 2.2** with JSON-encoded strings (no TypeAdapters — avoids code-gen complexity)
- `sessions` box — custom sessions only; presets are compile-time constants
- `settings` box — single JSON document, loaded at startup

---

## Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.6.1 | State management |
| `go_router` | ^14.8.1 | Navigation |
| `freezed_annotation` | ^2.4.4 | Immutable models + sealed unions |
| `hive` + `hive_flutter` | ^2.2.3 | Local persistence |
| `just_audio` | ^0.9.43 | Low-latency audio playback |
| `audio_service` | ^0.18.17 | Background audio + foreground service |
| `wakelock_plus` | ^1.3.1 | Keep screen on during sessions |
| `clock` | ^1.1.1 | Testable DateTime (fakeAsync) |
| `fake_async` | ^1.3.2 | Timer unit testing |

---

## Platform Configuration

### Android (`android/app/src/main/AndroidManifest.xml`)

Permissions already configured:
```xml
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>
```

- `minSdkVersion`: 24 (Android 7.0)
- `targetSdkVersion`: 34

### iOS (`ios/Runner/Info.plist`)

Background mode required:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>audio</string>
</array>
```

- Deployment target: iOS 14.0+

---

## Testing

See **[docs/TESTING.md](docs/TESTING.md)** for the full testing guide, including:

- Automated test suite (73 tests)
- Device testing checklist (background survival, audio ducking, wake lock)
- Performance targets and DevTools profiling
- Samsung battery optimization workarounds
- CI pipeline setup

Quick start:

```bash
flutter test          # All 73 tests
flutter analyze       # Zero issues expected
```

---

## Documentation

| Doc | Description |
|-----|-------------|
| [docs/VISION.md](docs/VISION.md) | Product vision, competitive analysis, feature roadmap |
| [docs/FLUTTER_ARCHITECTURE.md](docs/FLUTTER_ARCHITECTURE.md) | Definitive architecture decisions |
| [docs/TESTING.md](docs/TESTING.md) | Testing guide — unit, widget, device |
| [docs/AUDIO_IMPLEMENTATION.md](docs/AUDIO_IMPLEMENTATION.md) | Audio ducking and background audio deep-dive |
| [docs/TIMER_ENGINE_RESEARCH.md](docs/TIMER_ENGINE_RESEARCH.md) | Timer accuracy research and DateTime anchoring |
| [docs/REFERENCES.md](docs/REFERENCES.md) | Flutter packages, competitor apps, user quotes |
| [docs/sprints/SPRINT_PLAN.md](docs/sprints/SPRINT_PLAN.md) | Master sprint plan (Sprints 0–6) |

---

## Session Presets

| Session | Rounds | Work | Rest | Use Case |
|---------|--------|------|------|----------|
| Pro Boxing (Men) | 12 | 3:00 | 1:00 | Pro fight simulation |
| Pro Boxing (Women) | 10 | 2:00 | 1:00 | Pro women's rules |
| Amateur Boxing | 3 | 3:00 | 1:00 | Amateur fight |
| Heavy Bag | 8 | 3:00 | 1:00 | Power & combos |
| Shadow Boxing | 5 | 3:00 | 0:30 | Technique warm-up |
| Speed Bag | 6 | 2:00 | 0:30 | Speed & rhythm |
| Sparring | 6 | 3:00 | 1:00 | Partner work |
| Pad Work | 4 | 3:00 | 1:00 | Mitts with coach |
| Conditioning | 10 | 0:30 | 0:30 | HIIT boxing |
| Tabata | 8 | 0:20 | 0:10 | Tabata protocol |
| EMOM | 10 | 1:00 | 0:00 | Every Minute On the Minute |
| Beginner | 4 | 2:00 | 1:00 | New boxers |
| Youth Boxing | 4 | 1:30 | 1:00 | Junior fighters |
| Muay Thai | 5 | 3:00 | 2:00 | Muay Thai rules |
| MMA | 3 | 5:00 | 1:00 | MMA fight simulation |
| Kickboxing | 3 | 3:00 | 1:00 | Kickboxing rules |
| Amateur Women | 3 | 2:00 | 1:00 | Women's amateur |

---

## Development Workflow

```bash
# Before starting work
flutter analyze

# Run tests
flutter test

# Build runner (if models change)
dart run build_runner build --delete-conflicting-outputs

# Profile mode (for performance testing)
flutter run --profile
```

Branch: `claude/setup-project-config-lict0`

---

## License

Private — all rights reserved.
