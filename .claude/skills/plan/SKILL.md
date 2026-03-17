---
name: plan
description: Create an implementation plan for a boxing app feature, considering timer reliability, audio, background execution, and boxing UX.
argument-hint: "[feature description]"
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash, Agent, WebSearch
model: opus
context: fork
agent: planner
---

Create a detailed implementation plan for the following boxing app feature:

$ARGUMENTS

Consider the project vision in @docs/VISION.md and ensure the plan preserves:
- Timer reliability (never stops, never drifts)
- Audio correctness (plays over music, background-safe)
- Boxing UX (glove-friendly, gym-visible)
- Battery efficiency

Produce ordered implementation steps with file paths and testing strategy.
