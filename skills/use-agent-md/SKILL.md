---
name: use-agent-md
description: Prioritize reading AGENTS.md and applying AGENT.override.md rules according to the agents.md specification.
---

# Use AGENTS.md Rules

This skill enforces the usage of project-specific agent rules following the [agents.md specification](https://agents.md/).

## Discovery and Reading Instructions

Before executing development tasks, making architectural decisions, or writing code in a project, you MUST look for the presence of these configuration files in the project's root directory:

1. **`AGENTS.md`**: The primary file containing rules, conventions, and context for the AI agent in this project. This file is typically automatically loaded via the global `contextFileName` setting.
2. **`AGENT.override.md`**: An optional file containing environment-specific, user-specific, or temporary rule overrides.

When these files are present, you must read their contents before proceeding.

## Override and Application Logic

- **Baseline Rules**: Apply all rules, conventions, and context specified in `AGENTS.md` as your baseline behavior for the project.
- **Override Rules**: If `AGENT.override.md` is present, its rules **MUST OVERRIDE** any conflicting instructions found in `AGENTS.md`. 
- **Combination**: You should conceptually merge the two files, treating `AGENT.override.md` as the higher priority context. Any additions or modifications in the override file take strict precedence over the baseline rules.

Always adhere to the combined instructions strictly during all interactions within the project environment.
