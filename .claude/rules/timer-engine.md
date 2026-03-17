---
paths:
  - "lib/**/timer/**"
  - "lib/**/engine/**"
  - "lib/**/services/timer*"
---

# Timer Engine Rules

- NEVER use accumulated tick counting for elapsed time. Always use DateTime.now() difference.
- Timer logic MUST be independent of the widget tree and UI lifecycle.
- Timer MUST continue running when app is backgrounded or screen is locked.
- Audio cue triggers MUST be precise - fire at the exact configured moment.
- All timer state changes MUST be emitted via streams (not callbacks or direct setState).
- Handle AppLifecycleState transitions: recalculate elapsed time on resume.
- Support: pause, resume, skip round (forward/back), restart session, stop.
- Release all resources (timers, streams, audio) when session completes or is stopped.
- Warmup phase is optional and precedes the first round.
- Phase order: [warmup] -> round 1 work -> rest -> round 2 work -> rest -> ... -> complete.
