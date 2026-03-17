# Sprint 0: Foundation

## Objective
Initialize Flutter project with architecture, dependencies, data models, theme, and routing. App compiles, runs, and shows a home screen with preset sessions.

## Tasks

### Task 0.1: Flutter Project Initialization
- Run `flutter create` with correct org and project name
- Verify project compiles and runs on emulator
- **Agent**: None (manual or /scaffold skill)

### Task 0.2: Configure pubspec.yaml
- Add all dependencies with pinned versions
- Run `flutter pub get`
- Verify no dependency conflicts
- **Agent**: platform-integrator

### Task 0.3: Create Data Models
- `Session` model with @freezed (all fields from VISION.md)
- `TimerState` model with @freezed
- `TimerPhase` sealed union with @freezed
- `RoundOverride` model for per-round customization
- Run `dart run build_runner build`
- Write unit tests for model equality, copyWith, serialization
- **Agent**: state-manager

### Task 0.4: Create Preset Sessions
- Implement all 17 presets as `const` list in `preset_sessions.dart`
- Each preset is a fully configured Session instance
- Write test verifying all presets have valid values
- **Agent**: state-manager

### Task 0.5: Setup Theme
- Material 3 dark theme with custom color scheme
- Phase colors as constants (work=green, warning=amber, rest=red, warmup=blue)
- Timer display typography (monospace, 72sp+)
- Body text typography
- **Agent**: widget-builder

### Task 0.6: Setup Router
- GoRouter with 4 routes: home, timer, session-editor, settings
- Navigation from home → timer (with session parameter)
- Navigation from home → session-editor (new or edit mode)
- Navigation from home → settings
- **Agent**: widget-builder

### Task 0.7: Setup Storage Service
- Hive CE initialization in main.dart
- SessionRepository stub (will be fully implemented in Sprint 3)
- App settings box
- **Agent**: state-manager

### Task 0.8: Create Service Stubs
- TimerEngine stub (interface only, implemented in Sprint 1)
- AudioService stub (interface only, implemented in Sprint 1)
- WakelockService stub (implemented in Sprint 4)
- **Agent**: flutter-specialist

### Task 0.9: Create Screen Placeholders
- HomeScreen with preset session list (basic cards)
- TimerScreen placeholder ("Timer will be here")
- SessionEditorScreen placeholder
- SettingsScreen placeholder
- **Agent**: widget-builder

### Task 0.10: Verify & Test
- `flutter analyze` passes
- `flutter test` passes
- App runs on emulator
- Navigation works between all screens
- **Agent**: test-writer

## Definition of Done
- [ ] App compiles with zero warnings
- [ ] All models generate correctly
- [ ] Home screen shows 17 preset sessions
- [ ] Navigation works to all 4 screens
- [ ] Unit tests pass for all models
- [ ] Preset sessions all have valid values

## Estimated Effort
10 tasks, foundation complexity. This is the largest setup sprint.
