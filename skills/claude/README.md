# Claude Skills

This directory contains skills (tools) designed for use with [Claude](https://www.anthropic.com/claude) via the Anthropic API.

## How Claude Skills Work

Claude supports [tool use](https://docs.anthropic.com/en/docs/tool-use), which allows it to call externally defined functions during a conversation. Each tool is described to Claude using a JSON schema, and Claude decides when to invoke a tool based on the conversation context.

A Claude tool definition looks like this:

```json
{
  "name": "skill_name",
  "description": "A clear description of what this skill does and when to use it.",
  "input_schema": {
    "type": "object",
    "properties": {
      "parameter_one": {
        "type": "string",
        "description": "Description of the first parameter."
      }
    },
    "required": ["parameter_one"]
  }
}
```

## Directory Structure

Each skill lives in its own subdirectory:

```
claude/
└── <skill-name>/
    ├── README.md        # Description, inputs, outputs, and usage examples
    ├── skill.json       # Tool definition (JSON schema for Claude)
    └── implementation/  # Optional: implementation code
```

## Adding a Claude Skill

1. Create a new subdirectory under `skills/claude/` named after your skill.
2. Add a `skill.json` with the tool definition conforming to the Anthropic tool schema.
3. Add a `README.md` explaining what the skill does, its parameters, and example usage.
4. Optionally, add implementation code in an `implementation/` subfolder.

## References

- [Anthropic Tool Use Documentation](https://docs.anthropic.com/en/docs/tool-use)
- [Claude API Reference](https://docs.anthropic.com/en/api/messages)
