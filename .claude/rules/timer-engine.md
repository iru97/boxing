---
paths:
  - "lib/**/timer/**"
  - "lib/**/engine/**"
  - "lib/**/services/timer*"
---

# Timer Engine Rules

## Known Issue: Flutter Issue #25435
dart:async timers drift 1-30s+ or stop entirely when app is backgrounded/screen locked on iOS.
Use WidgetsBindingObserver to detect lifecycle changes and re-sync against wall-clock time on resume.

## Core Rules
- NEVER use accumulated tick counting for elapsed time. Always use DateTime.now() difference.
- Use Timer.periodic ONLY for UI refresh ticks (~100ms). Actual timing via DateTime comparisons.
- Timer logic MUST be independent of the widget tree and UI lifecycle.
- Timer MUST continue running when app is backgrounded or screen is locked.
- Audio cue triggers MUST be precise (<200ms latency) - fire at the exact configured moment.
- All timer state changes MUST be emitted via streams (not callbacks or direct setState).
- Handle AppLifecycleState transitions: recalculate elapsed time on resume from DateTime.
- Support: pause, resume, skip round (forward/back), restart session, stop.
- Release all resources (timers, streams, audio) when session completes or is stopped.

## Background Survival
- During rest periods, play a SILENT audio track to prevent the OS from killing the process.
- Use androidStopForegroundOnPause: false to maintain foreground service during pauses.
- Handle Android Doze mode via foreground service exemption.
- Handle aggressive battery optimization on Samsung/Huawei/Xiaomi.

## Phase Order
- Warmup phase is optional and precedes the first round.
- Phase order: [warmup] -> round 1 work -> [warning] -> rest -> round 2 work -> ... -> complete.
- Warning is a sub-phase within work (last N seconds), not a separate phase in the state machine.
