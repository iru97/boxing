# Claude Code Configuration - Boxing App

## Architecture Standards

### Flutter/Dart Conventions
- Follow effective Dart style guide
- Use `const` constructors wherever possible
- Prefer composition over inheritance for widgets
- Keep widgets small and focused (max ~100 lines)
- Separate business logic from UI (no logic in build methods)
- Use `final` for immutable fields

### Project Structure (Target)
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/       # App-wide constants, preset sessions
│   ├── theme/           # App theme, colors, typography
│   └── utils/           # Utility functions
├── features/
│   ├── timer/           # Core timer screen (background-safe)
│   ├── session/         # Session configuration and management
│   └── settings/        # App settings
├── models/              # Data models (Session, TimerState, TimerPhase)
├── services/            # Platform services (timer engine, audio, wakelock, storage)
└── widgets/             # Shared widgets (timer display, phase indicator)
```

### Timer Engine Requirements
- Must run accurately regardless of UI state
- Must survive app backgrounding and screen lock
- Must trigger audio cues at exact moments (round start, warning, round end)
- Must report state changes to UI via streams/providers
- Must handle pause, resume, skip round, restart session

### Audio Requirements
- Sounds must play over other apps' audio (duck or mix)
- Volume override option (force audible even if phone is on low)
- Authentic boxing bell sounds (not generic beeps)
- Must work with screen locked via foreground service

### Data Model (Core)
```
Session: id, name, rounds, roundDuration, restDuration,
         warningTime, soundPack, autoAdvance, keepScreenOn,
         warmupDuration, isPreset

TimerState: currentRound, totalRounds, phase, timeRemaining,
            totalElapsed, isPaused

TimerPhase: warmup | work | rest | complete
```

## Agents

### Reasoning & Review Agents (read-only, no code changes)
- **planner** - Architecture planning before complex features
- **code-reviewer** - Post-implementation quality and boxing UX review
- **debugger** - Bug investigation (timer, audio, background)
- **researcher** - Boxing domain, Flutter ecosystem, competitors
- **ux-designer** - Glove-friendly, gym-visible interface decisions

### Implementation Agents (write code)
- **widget-builder** - Flutter widgets following boxing UX rules
- **state-manager** - Riverpod providers, controllers, state classes
- **test-writer** - Unit, widget, and integration tests
- **flutter-specialist** - Audio, background execution, timer precision
- **platform-integrator** - Android/iOS manifests, permissions, native config

## Skills (Slash Commands)

### Project Management
- `/status` - Project health check
- `/review` - Code review with boxing context
- `/plan` - Implementation planning

### Implementation
- `/scaffold` - Initialize full Flutter project structure
- `/feature <name>` - Scaffold a complete feature module
- `/widget <name>` - Create a new widget
- `/test [file|feature|all]` - Generate and run tests
- `/analyze` - Run flutter analyze and fix issues
- `/build [android|ios]` - Build and fix errors

### Validation
- `/timer-test` - Verify timer accuracy and background behavior
- `/session-validate` - Validate session model and presets
- `/ux-review` - Check boxing UX compliance

## Team Orchestration
- Agents can work in parallel using worktree isolation
- Max team size: 5 concurrent agents
- Typical workflow:
  1. `/plan` before complex features
  2. Implementation agents build in parallel (widget + state + platform)
  3. `/test` to verify
  4. `/review` to catch issues
  5. `/analyze` + `/build` to finalize

## References
- @../docs/VISION.md - Project vision and competitive analysis
- @../CLAUDE.md - Root project instructions
- @rules/ - Path-specific rules
