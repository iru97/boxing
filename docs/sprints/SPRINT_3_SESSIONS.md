# Sprint 3: Sessions

## Objective
Full session management: create, edit, save, delete, and load custom sessions. Data persists across app restarts. Presets are always available.

## Can Run In Parallel With: Sprint 2 (Timer Screen)

## Tasks

### Task 3.1: Storage Service Implementation
- Initialize Hive CE in main.dart (before runApp)
- Register type adapters for Session model
- Create two boxes: `presets` (seeded on first launch) and `custom_sessions`
- Methods: init(), close()
- Handle migration if data format changes (version stamp)
- **Agent**: state-manager

### Task 3.2: Session Repository
- `SessionRepository` class wrapping Hive operations
- Methods:
  - `List<Session> getAllPresets()` - Returns built-in presets
  - `List<Session> getCustomSessions()` - Returns user sessions
  - `List<Session> getAll()` - Combined, presets first
  - `Session? getById(String id)` - Lookup
  - `Future<void> saveSession(Session session)` - Create or update
  - `Future<void> deleteSession(String id)` - Delete (only custom)
  - `Future<Session> duplicateSession(Session session)` - Copy with new ID
- Handles serialization: Duration ↔ int milliseconds
- **Agent**: state-manager

### Task 3.3: Session Providers
- `sessionRepositoryProvider` - Repository instance
- `allSessionsProvider` - FutureProvider<List<Session>> (presets + custom)
- `customSessionsProvider` - FutureProvider<List<Session>>
- `sessionByIdProvider(String id)` - Family provider for single session
- Invalidate/refresh on CRUD operations
- **Agent**: state-manager

### Task 3.4: Session List Screen (Home)
- Replace placeholder with full implementation
- Two sections with headers: "Quick Start" and "My Sessions"
- Session card shows: name, "X rounds x M:SS", total duration estimate
- Visual distinction between presets and custom (icon or badge)
- Tap → session summary bottom sheet (from Sprint 2)
- Long press → action menu (Edit, Duplicate, Delete) for custom sessions
- Long press → action menu (Duplicate) for presets (cannot edit/delete)
- FAB "+" to create new session
- **Agent**: widget-builder

### Task 3.5: Session Editor Screen
- Full form for session configuration
- Fields:
  - **Name**: Text input, required, max 50 chars
  - **Rounds**: Stepper (1-30), default 3
  - **Round Duration**: Duration picker or slider (15s-10min), default 3:00
  - **Rest Duration**: Duration picker or slider (0s-5min), default 1:00
  - **Warning Time**: Chip selector (Off, 5s, 10s, 15s, 30s), default 10s
  - **Warmup**: Chip selector (Off, 5s, 10s, 15s, 30s), default 10s
  - **Sound Pack**: Dropdown with preview play button
  - **Auto-advance**: Switch, default true
  - **Keep Screen On**: Switch, default true
- Session summary at bottom: "8 rounds, 32:00 total"
- Save button in app bar
- **Agent**: widget-builder

### Task 3.6: Duration Picker Widget
- Custom widget for selecting durations (used for round and rest durations)
- Slider with 15-second increments
- Common preset chips below slider (30s, 1:00, 2:00, 3:00, 5:00)
- Current value displayed prominently
- **Agent**: widget-builder

### Task 3.7: Session Editor State Management
- `SessionEditorNotifier` managing form state
- Initialize from existing session (edit) or defaults (new)
- Validate all constraints on save
- Compute derived values (total duration, total rest)
- Handle save: create new or update existing via repository
- **Agent**: state-manager

### Task 3.8: Per-Round Override UI
- Toggle "Customize individual rounds" (collapsed by default)
- When expanded: list of rounds with individual duration pickers
- Default: "Same as session default (3:00)"
- Override: tap to change specific round's duration
- Clear override: reset to session default
- **Agent**: widget-builder

### Task 3.9: Session Validation
- Validation rules:
  - Name: non-empty, max 50 chars
  - Rounds: 1-30
  - Round duration: 15s-600s (10min)
  - Rest duration: 0s-300s (5min)
  - Warning time < round duration
  - At least one round override must differ from default (if overrides enabled)
- Show inline validation errors
- Disable save button if invalid
- **Agent**: state-manager

### Task 3.10: Tests
- Repository CRUD operations (save, load, delete, duplicate)
- Serialization roundtrip (Session → Hive → Session equality)
- Session validation rules (all edge cases)
- Presets cannot be deleted
- Editor form state management
- Session list provider reflects CRUD changes
- **Agent**: test-writer

## Definition of Done
- [ ] Custom sessions persist across app restart
- [ ] All 17 presets always available and immutable
- [ ] Create new session with all configurable fields
- [ ] Edit existing custom session
- [ ] Duplicate any session (preset or custom)
- [ ] Delete custom sessions (with confirmation)
- [ ] Per-round overrides work and persist
- [ ] Session editor validates all constraints
- [ ] Total duration preview is accurate
- [ ] Sound pack preview plays in editor
