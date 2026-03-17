---
name: review
description: Run a code review on recent changes using the code-reviewer agent, with boxing app-specific checks for timer reliability and audio correctness.
argument-hint: "[branch-or-commit]"
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash, Agent
model: sonnet
context: fork
agent: code-reviewer
---

Review the recent code changes in this boxing training timer project.

If an argument is provided, review changes from that branch or commit: $ARGUMENTS

Otherwise, review unstaged and staged changes using `git diff` and `git diff --cached`.

Pay special attention to:
- Timer engine reliability (background-safe, no drift)
- Audio service correctness (plays over music, pre-loaded)
- Resource cleanup (dispose, stream subscriptions, wake lock)
- Boxing UX (glove-friendly, gym-visible, phase-obvious)

Provide a thorough code review organized by severity.
