# Sprint 1: Timer Engine

## Objective
Build the core timer engine that accurately counts rounds, transitions phases, and plays audio cues. This sprint focuses on correctness and reliability in the foreground.

## Tasks

### Task 1.1: TimerEngine Core
- Implement `TimerEngine` class in `lib/services/timer_engine.dart`
- DateTime-based elapsed time (NOT tick accumulation)
- `Timer.periodic(100ms)` for UI refresh ticks only
- `StreamController<TimerState>` for state emission
- Methods: start(session), pause(), resume(), stop(), skipForward(), skipBack(), dispose()
- **Agent**: flutter-specialist
- **Critical**: This is the most important class in the entire app

### Task 1.2: Timer State Machine
- Phase transitions: warmup → work → rest → work → rest → ... → complete
- Warning detection: when `timeRemaining <= session.warningTime`, set `isWarning = true`
- Round counting: increment on work→rest transition
- Handle edge cases:
  - Session with 0s warmup (skip warmup)
  - Session with 0s rest (no rest between rounds)
  - Single-round sessions
  - Session with per-round overrides
- **Agent**: flutter-specialist

### Task 1.3: Pause/Resume Logic
- On pause: record `_pausedAt = DateTime.now()`, cancel periodic timer
- On resume: calculate pause duration, adjust `_phaseStartTime` forward by pause duration, restart periodic timer
- Resume countdown option: 3-2-1 count before actually resuming (Phase 5 polish, stub for now)
- **Agent**: flutter-specialist

### Task 1.4: Audio Service (Foreground)
- Implement `BoxingAudioService` in `lib/services/audio_service.dart`
- Use `just_audio` AudioPlayer
- Methods: preloadSounds(soundPack), playRoundStart(), playWarning(), playRoundEnd(), playSessionComplete(), dispose()
- Pre-load all 4 sounds on session start
- Simple foreground playback (background support in Sprint 4)
- **Agent**: flutter-specialist

### Task 1.5: Sound Assets
- Create `assets/sounds/classic_bell/` directory
- Source or generate 4 audio files:
  - `round_start.wav` (~200KB) - Single bell strike
  - `warning.wav` (~200KB) - Clapper/double tap
  - `round_end.wav` (~300KB) - Triple bell strike
  - `session_complete.wav` (~400KB) - Long bell ring
- Register assets in pubspec.yaml
- **Note**: Use royalty-free boxing bell samples or generate with audio tools

### Task 1.6: Timer-Audio Integration
- TimerEngine fires events to AudioService at phase transitions
- Sequence: phase changes → audio plays → state emitted to UI
- Audio must not block state emission (fire-and-forget)
- Handle audio load failures gracefully (timer continues without sound)
- **Agent**: flutter-specialist

### Task 1.7: Timer Providers
- `timerEngineProvider` - Singleton TimerEngine
- `timerStateProvider` - StreamProvider<TimerState> from engine
- `activeSessionProvider` - StateProvider<Session?> for currently loaded session
- `audioServiceProvider` - Singleton AudioService
- `isTimerRunningProvider` - Derived bool from timerState
- **Agent**: state-manager

### Task 1.8: Unit Tests - Timer Accuracy
- Use `fakeAsync` to control time progression
- Test: 3-minute round completes within ±100ms of 3:00
- Test: 10s warning fires at correct moment
- Test: total session duration matches expected for preset configs
- Test: timer does not drift over 12 rounds (36+ minutes simulated)
- **Agent**: test-writer

### Task 1.9: Unit Tests - State Machine
- Test: full phase sequence for standard session (warmup→work→rest→...→complete)
- Test: no warmup session skips directly to work
- Test: no rest session (0s rest) goes directly work→work
- Test: per-round overrides apply correctly
- Test: skip forward advances to next phase/round
- Test: skip back restarts current round from beginning
- **Agent**: test-writer

### Task 1.10: Unit Tests - Pause/Resume
- Test: pause preserves remaining time
- Test: resume continues from correct time
- Test: multiple pause/resume cycles don't accumulate drift
- Test: pause during warning maintains warning state on resume
- **Agent**: test-writer

## Definition of Done
- [ ] Timer counts down accurately (unit tests prove ±100ms)
- [ ] All phase transitions fire correctly
- [ ] Warning triggers at configured time
- [ ] Bell sounds play at each transition
- [ ] Pause/resume works without drift
- [ ] Skip forward/back works
- [ ] All 17 presets run correctly
- [ ] 90%+ test coverage on timer engine

## Technical Notes
- TimerEngine MUST have zero Flutter dependencies (pure Dart)
- AudioService uses just_audio directly (no audio_service wrapper yet)
- This sprint is foreground-only; background survival is Sprint 4
