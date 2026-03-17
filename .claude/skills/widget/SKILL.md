---
name: widget
description: Create a new Flutter widget following project conventions, theme, and boxing UX requirements.
argument-hint: "<widget-name> [description]"
user-invocable: true
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
model: sonnet
context: fork
agent: widget-builder
---

Create a new Flutter widget: $ARGUMENTS

Before building:
1. Check existing widgets in `lib/widgets/` and `lib/features/` to avoid duplication
2. Use the project theme from `lib/core/theme/`
3. Follow boxing UX rules (glove-friendly, gym-visible, phase colors)

After building:
1. Run `flutter analyze` on the new file
2. Note if the widget needs a corresponding test
