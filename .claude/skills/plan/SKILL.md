---
name: plan
description: Create an implementation plan for a feature or change using the planner agent.
argument-hint: "[feature description]"
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash, Agent, WebSearch
model: opus
context: fork
agent: planner
---

Create a detailed implementation plan for the following:

$ARGUMENTS

Analyze the current codebase, identify all files that need to change, and produce a step-by-step implementation guide.
