---
name: ux-review
description: Review UI code for boxing-specific UX requirements - glove-friendly targets, gym visibility, phase clarity, and minimal cognitive load.
argument-hint: "[screen or widget name]"
user-invocable: true
allowed-tools: Read, Grep, Glob
model: sonnet
context: fork
agent: ux-designer
---

Review the UI code for boxing-specific UX compliance.

If a specific screen/widget is provided, focus on: $ARGUMENTS

Check against these boxing UX requirements:
1. **Glove-friendly**: Touch targets >= 64dp during active workout
2. **Gym visibility**: Timer readable from 2-3 meters (large font, high contrast)
3. **Phase clarity**: Work/rest/warning phases instantly distinguishable by color
4. **Minimal interaction**: No complex gestures or decisions during rounds
5. **Progress visibility**: Current round and total always visible
6. **Pre-workout simplicity**: Session selection/configuration is intuitive

Report violations with specific widget references and recommended fixes.
