---
name: session-validate
description: Validate session configuration model completeness, preset correctness, and data integrity.
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash
model: sonnet
context: inline
---

Validate the session configuration system:

1. **Check Session model**: Read the Session data model and verify all required fields:
   - id, name, rounds (1-30), roundDuration (15s-10min), restDuration (0s-5min)
   - warningTime, soundPack, autoAdvance, keepScreenOn, warmupDuration, isPreset
2. **Validate presets**: Check built-in session presets match the specifications in @docs/VISION.md
3. **Check constraints**: Verify validation logic enforces valid ranges
4. **Check serialization**: Verify sessions can be saved/loaded correctly (Hive or SharedPreferences)
5. **Check equality**: Verify Session equality and hashCode if used in collections

Report completeness score and list any missing fields, incorrect presets, or validation gaps.
