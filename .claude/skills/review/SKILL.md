---
name: review
description: Run a code review on recent changes using the code-reviewer agent.
argument-hint: "[branch-or-commit]"
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash, Agent
model: sonnet
context: fork
agent: code-reviewer
---

Review the recent code changes in this project.

If an argument is provided, review changes from that branch or commit: $ARGUMENTS

Otherwise, review unstaged and staged changes using `git diff` and `git diff --cached`.

Provide a thorough code review with actionable feedback organized by severity.
