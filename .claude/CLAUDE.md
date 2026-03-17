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
│   ├── timer/           # Core timer engine (background-safe)
│   ├── session/         # Session configuration and management
│   ├── audio/           # Sound playback service
│   └── settings/        # App settings
├── models/              # Data models (Session, TimerState, etc.)
├── services/            # Platform services (audio, wakelock, storage)
└── widgets/             # Shared widgets
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
- 10-second warning must be distinct from round start/end
- Must work with screen locked via foreground service

### Data Model (Core)
```dart
// Session: A complete training configuration
// - id, name, rounds, roundDuration, restDuration
// - warningTime, soundPack, autoAdvance, keepScreenOn
// - warmupDuration, isPreset (built-in vs user-created)

// TimerState: Current state of the running timer
// - currentRound, totalRounds, phase (work/rest/warmup/complete)
// - timeRemaining, totalElapsed, isPaused
```

## Agent & Skill Usage

### Available Agents
- **planner**: Architecture and implementation planning (use before complex features)
- **code-reviewer**: Post-implementation quality review
- **debugger**: Bug investigation and resolution
- **researcher**: Codebase exploration and documentation
- **ux-designer**: UI/UX decisions for boxing-specific interfaces
- **flutter-specialist**: Flutter/Dart best practices and platform integration

### Available Skills
- `/review` - Code review on recent changes
- `/plan` - Implementation planning
- `/status` - Project status and health
- `/timer-test` - Verify timer accuracy and background behavior
- `/session-validate` - Validate session configuration completeness

## Team Orchestration
- Agents can work in parallel using worktree isolation
- Max team size: 5 concurrent agents
- Use planner agent before starting complex multi-file changes
- Use code-reviewer after implementations
- Use ux-designer for any screen layout or interaction decisions

## References
- @../docs/VISION.md - Project vision and competitive analysis
- @../CLAUDE.md - Root project instructions
- @rules/ - Path-specific rules
