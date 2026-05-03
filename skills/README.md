# AI Skills

This directory contains skills designed to extend AI assistants such as **Claude** (Anthropic) and **GitHub Copilot**. Skills are discrete, reusable capabilities — functions or tools — that the AI can invoke to perform specific tasks.

## Directory Structure

```
skills/
├── claude/     # Skills specific to Claude (Anthropic)
├── copilot/    # Skills specific to GitHub Copilot
└── shared/     # Skills that work across both Claude and Copilot
```

## What is a Skill?

A skill is a named, self-contained capability that can be:

- **Called by an AI assistant** during a conversation to perform a task
- **Defined with a schema** (input/output types and descriptions)
- **Implemented** as a function, script, or API call

### Claude Skills (Tools)

Claude uses the [tool use](https://docs.anthropic.com/en/docs/tool-use) API. Each skill is defined as a JSON schema describing the function name, description, and input parameters. See [`claude/README.md`](./claude/README.md) for details.

### GitHub Copilot Skills (Extensions)

GitHub Copilot skills can be surfaced via [Copilot Extensions](https://docs.github.com/en/copilot/building-copilot-extensions/about-building-copilot-extensions). Each skill is described with a name, description, and parameter schema. See [`copilot/README.md`](./copilot/README.md) for details.

### Shared Skills

Skills that have a platform-agnostic design can live in `shared/` and be adapted for use with either Claude or Copilot. See [`shared/README.md`](./shared/README.md) for details.

## Adding a New Skill

1. Decide which subdirectory is appropriate (`claude/`, `copilot/`, or `shared/`).
2. Create a new folder named after your skill (e.g., `skills/shared/my-skill/`).
3. Add a `README.md` describing what the skill does, its inputs and outputs.
4. Add the skill definition file (`skill.json` or platform-specific equivalent).
5. Add the implementation (if applicable).
