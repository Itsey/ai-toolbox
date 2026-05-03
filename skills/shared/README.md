# Shared Skills

This directory contains skills with a platform-agnostic design that can be adapted for use with both **Claude** (Anthropic) and **GitHub Copilot**.

## When to Put a Skill Here

Place a skill in `shared/` when:

- The core logic is the same regardless of which AI platform calls it.
- The skill can be adapted to both the Anthropic tool schema and the OpenAI function calling schema with minimal changes.

Platform-specific adaptations (e.g., the exact JSON schema format) should be documented in the skill's `README.md`.

## Directory Structure

Each shared skill lives in its own subdirectory:

```
shared/
└── <skill-name>/
    ├── README.md        # Description, inputs, outputs, platform adaptation notes
    ├── skill.json       # Core skill definition (platform-agnostic)
    └── implementation/  # Optional: implementation code
```

## Adding a Shared Skill

1. Create a new subdirectory under `skills/shared/` named after your skill.
2. Add a `skill.json` with the core skill definition.
3. Add a `README.md` explaining:
   - What the skill does
   - Its input parameters and expected output
   - How to adapt the definition for Claude (see [`../claude/README.md`](../claude/README.md))
   - How to adapt the definition for Copilot (see [`../copilot/README.md`](../copilot/README.md))
4. Optionally, add implementation code in an `implementation/` subfolder.
