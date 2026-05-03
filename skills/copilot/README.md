# GitHub Copilot Skills

This directory contains skills designed for use with [GitHub Copilot](https://github.com/features/copilot) via [Copilot Extensions](https://docs.github.com/en/copilot/building-copilot-extensions/about-building-copilot-extensions).

## How Copilot Skills Work

GitHub Copilot Extensions allow you to integrate external tools and services into Copilot Chat. Skills are defined as functions that Copilot can invoke, each described with a name, description, and parameter schema following the [OpenAI function calling](https://platform.openai.com/docs/guides/function-calling) format.

A Copilot skill (function) definition looks like this:

```json
{
  "name": "skill_name",
  "description": "A clear description of what this skill does and when to use it.",
  "parameters": {
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
copilot/
└── <skill-name>/
    ├── README.md        # Description, inputs, outputs, and usage examples
    ├── skill.json       # Skill definition (OpenAI function calling schema)
    └── implementation/  # Optional: implementation code
```

## Adding a Copilot Skill

1. Create a new subdirectory under `skills/copilot/` named after your skill.
2. Add a `skill.json` with the function definition following the OpenAI function calling schema.
3. Add a `README.md` explaining what the skill does, its parameters, and example usage.
4. Optionally, add implementation code in an `implementation/` subfolder.

## References

- [Building Copilot Extensions](https://docs.github.com/en/copilot/building-copilot-extensions/about-building-copilot-extensions)
- [GitHub Copilot Extensions Quickstart](https://docs.github.com/en/copilot/building-copilot-extensions/building-a-copilot-extension/building-a-copilot-skillset-for-your-copilot-extension)
- [OpenAI Function Calling](https://platform.openai.com/docs/guides/function-calling)
