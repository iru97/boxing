# Sprint 2: Timer Screen

## Objective
Build the full timer UI with large countdown display, circular progress, phase colors, and glove-friendly controls. Must be usable during a real boxing workout.

## Can Run In Parallel With: Sprint 3 (Sessions)

## Tasks

### Task 2.1: Timer Display Widget
- Large monospace countdown text (72-96sp)
- Format: `M:SS` for times < 10min, `MM:SS` for >= 10min
- Zero-padded seconds (e.g., 2:07 not 2:7)
- Use `Text` widget with monospace font (RobotoMono or similar)
- Wrap in `RepaintBoundary` to isolate repaints
- Only the time text rebuilds on tick (not the whole screen)
- **Agent**: widget-builder

### Task 2.2: Circular Progress Ring
- `CustomPainter` drawing arc on canvas
- Sweep angle: `(timeRemaining / totalPhaseDuration) * 2π`
- Line width: 10dp, rounded stroke caps
- Color matches current phase
- Background track: subtle grey
- Smooth: repaints every 100ms synced with timer tick
- **Agent**: widget-builder

### Task 2.3: Phase Color System
- Constant map: `TimerPhase → Color`
  - warmup: Colors.blue[700]
  - work: Colors.green[600]
  - warning: Colors.amber[700]
  - rest: Colors.red[600]
  - complete: Colors.white
- Applied to: progress ring, background tint, phase label, control button accents
- Immediate switch on phase change (no gradual fade)
- Background: dark base with subtle phase-colored tint (10-15% opacity)
- **Agent**: widget-builder

### Task 2.4: Round Indicator
- "ROUND 3 / 8" text, centered above timer
- 24sp, medium weight
- Animates briefly on round change (scale pulse 1.0 → 1.1 → 1.0, 200ms)
- **Agent**: widget-builder

### Task 2.5: Phase Label
- "WARMUP", "WORK", "REST", "COMPLETE" text below timer
- 28-32sp, phase-colored, bold
- Changes immediately with phase transition
- **Agent**: widget-builder

### Task 2.6: Timer Controls
- Three buttons in a row at bottom:
  - Skip Back (◀): 64dp, restarts current round
  - Pause/Resume (⏸/▶): 80dp, center, primary action
  - Skip Forward (▶): 64dp, advances to next phase
- All buttons:
  - Circular shape
  - Haptic feedback on tap
  - Phase-colored accent
  - Icon-only (no text labels during workout)
- **Agent**: widget-builder

### Task 2.7: Stop/Exit Button
- Small icon button in top-left corner (back arrow or X)
- Shows confirmation dialog: "End workout? You're on round X of Y"
- Confirm → navigate back to home
- Cancel → return to timer
- **Agent**: widget-builder

### Task 2.8: Total Elapsed Display
- Small text at bottom: "Total: 12:33"
- 14sp, subtle grey
- Shows cumulative time since session started (including rest)
- **Agent**: widget-builder

### Task 2.9: Timer Screen Layout (Portrait)
- Full screen, dark background
- Top: Round indicator
- Center: Circular progress ring with countdown text inside
- Below center: Phase label
- Bottom: Controls row
- Very bottom: Total elapsed
- Use `SafeArea` for notch/island devices
- **Agent**: widget-builder

### Task 2.10: Timer Screen Layout (Landscape)
- Reorganize for horizontal space:
  - Left half: large timer + progress ring
  - Right half: round indicator, phase label, controls
- Or: single row with timer left, info+controls right
- **Agent**: widget-builder

### Task 2.11: Session Start Flow
- From home: tap session card
- Show session summary bottom sheet:
  - Session name, rounds, round duration, rest, warning, total time
  - "START" button (large, green)
  - "EDIT" button (if custom session)
- On START: navigate to timer screen, pre-load audio, begin warmup/round 1
- **Agent**: widget-builder

### Task 2.12: Session Complete Screen
- Shown when timer reaches `complete` phase
- Display: session name, total time, rounds completed
- Buttons: "Done" (go home), "Repeat" (restart same session)
- **Agent**: widget-builder

### Task 2.13: Widget Tests
- Timer display format correctness (M:SS, MM:SS)
- Phase color mapping
- Controls respond to taps (mock timer provider)
- Round indicator shows correct values
- Landscape layout renders without overflow
- **Agent**: test-writer

## Definition of Done
- [ ] Timer screen shows accurate countdown synced with engine
- [ ] Phase colors change immediately on transition
- [ ] Progress ring animates smoothly at 60fps
- [ ] All controls work (pause, resume, skip, stop)
- [ ] Text readable from 2+ meters away
- [ ] All touch targets >= 64dp
- [ ] Both portrait and landscape work
- [ ] Session start flow: tap → summary → start
- [ ] Session complete screen shows summary
