---
name: scaffold
description: Scaffold the initial Flutter project structure with all folders, base files, theme, and dependencies configured for the boxing timer app.
user-invocable: true
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
model: opus
context: inline
---

Scaffold or verify the complete Flutter project structure for the boxing timer app.

## Full Target Structure

```
lib/
├── main.dart                        # Entry point, Hive init, ProviderScope
├── app.dart                         # MaterialApp, theme, routing
├── core/
│   ├── constants/
│   │   ├── app_constants.dart       # App-wide constants
│   │   └── preset_sessions.dart     # Built-in session presets
│   ├── theme/
│   │   ├── app_theme.dart           # ThemeData configuration
│   │   ├── app_colors.dart          # Color palette (phase colors, etc.)
│   │   └── app_typography.dart      # Text styles (timer display, labels)
│   └── utils/
│       ├── duration_extensions.dart  # Duration formatting helpers
│       └── app_logger.dart          # Logging utility
├── models/
│   ├── session.dart                 # Session configuration model
│   ├── timer_state.dart             # Timer runtime state
│   └── timer_phase.dart             # Enum: warmup, work, rest, complete
├── services/
│   ├── timer_engine.dart            # Core timer logic (UI-independent)
│   ├── audio_service.dart           # Sound playback with background support
│   ├── storage_service.dart         # Hive-based session persistence
│   └── wakelock_service.dart        # Screen wake lock management
├── features/
│   ├── timer/                       # Active timer screen
│   │   ├── timer_screen.dart
│   │   ├── timer_controller.dart
│   │   └── widgets/
│   ├── session/                     # Session picker and editor
│   │   ├── session_list_screen.dart
│   │   ├── session_editor_screen.dart
│   │   ├── session_provider.dart
│   │   └── widgets/
│   └── settings/                    # App settings
│       ├── settings_screen.dart
│       └── settings_provider.dart
└── widgets/                         # Shared reusable widgets
    ├── round_indicator.dart
    ├── phase_indicator.dart
    └── large_timer_display.dart
```

## Steps

1. Check if `pubspec.yaml` exists (Flutter project already initialized)
2. If not, run `flutter create --org com.boxing --project-name boxing .` or create pubspec.yaml
3. Create all directories
4. Create stub files with proper imports and class declarations
5. Configure `pubspec.yaml` with required dependencies
6. Run `flutter pub get`
7. Run `flutter analyze` to verify no errors
8. Report what was created
