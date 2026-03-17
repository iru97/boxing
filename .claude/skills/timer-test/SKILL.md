---
name: timer-test
description: Verify timer accuracy, background behavior, and audio cue timing for the boxing timer engine.
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash
model: sonnet
context: inline
---

Run a comprehensive verification of the timer engine:

1. **Find timer tests**: Search for test files related to the timer engine (`*timer*test*`, `*engine*test*`)
2. **Run timer tests**: Execute `flutter test` for timer-related test files
3. **Check timer implementation**: Read the timer engine code and verify:
   - Uses DateTime-based elapsed time (not accumulated ticks)
   - Handles AppLifecycleState changes (pause, resume, detach)
   - Fires audio cues at correct moments (round start, warning, round end)
   - Properly manages dispose/cleanup
4. **Check audio integration**: Verify audio service is triggered by timer events
5. **Check background service**: Verify foreground service configuration

Report findings with pass/fail for each check and specific file:line references for any issues.
