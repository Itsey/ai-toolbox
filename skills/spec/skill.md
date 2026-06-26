---
name: spec
description: A specification skill to shape and map out a feature to be built.
metadata:
  author: jim
  version: "2.0"
---

# Spec

You create a task file that precisely describes a requirement, ready for the ralphy queue. You do this by invoking the Analyst agent (`ralphyanalyst.agent.md`) to hold a structured conversation with the user.

You are invoked when the user asks to "spec" something, "create a task", or "capture this idea".

## On Start

If the user types `/spec` with no further information, check `docs/backlog.md` for pending ideas. Present the items and ask the user to select one. Once selected and fully specced, remove it from the backlog.

If a description was provided, begin immediately with the Analyst.

## Conversation

Invoke the **Analyst agent** to drive the conversation. The Analyst works through structured phases (Listen → Clarify → Challenge → Draft → Confirm) and will not produce the task file until the user has explicitly approved a draft. Do not shortcut this process.

The Analyst's job is to define *what* must be true when the feature is done — not *how* to build it. Do not let implementation details drive the spec.

## Reference Numbers

Each task file must carry a unique, incrementing reference number. Before writing the file, read all existing files in `docs/tasks/` to find the highest `reference:` value and increment by one. Start at 1 if no tasks exist yet.

## Output

The Analyst produces a single task file in `docs/tasks/`. Use a short kebab-case filename (two to four words). Set `status: draft` while the conversation is in progress; update to `status: todo` when the user confirms the spec is complete.

Any unrelated ideas or future requirements that surface during the session go to `docs/backlog.md`, not the task file. Use this format:

```markdown
- [ ] **<Short title>** — <One sentence description.>
```

## Task File Format

Task files live in `docs/tasks/` as markdown with YAML frontmatter. Every task file must use this format exactly — do not omit sections, write "None" if a section does not apply.

```markdown
---
status: todo
title: <Short imperative title — e.g. "Add search box to skills dashboard">
created: <YYYY-MM-DD>
priority: <high | medium | low>
reference: <incrementing integer>
---
# Reference
<Reference number + one-line description of the change>

# What
<One paragraph describing what the user sees or what the system does when this is complete. Observable outcomes only.>

# Why
<One paragraph explaining the motivation — the user's goal, the pain being solved, or the opportunity. Include linked tickets or prior context if available.>

# Acceptance

- <Concrete, testable criterion. Given/When/Then format preferred.>
- <...>

# Out of Scope

- <Anything that might look related but is explicitly excluded.>
- <...>

# Assumptions & Constraints

- <Each assumption that, if wrong, would invalidate the spec.>
- <Performance, security, or compatibility constraints.>
- <...>
```

**Status values:**

- `draft` — being written; not ready for ralph to pick up
- `todo` — confirmed and ready to pick up
- `doing` — claimed by an engineer or agent
- `done` — complete
- `blocked` — needs human input; skip

## Handoff

When the task file is written and status is set to `todo`, confirm its location:

> **Spec written to `docs/tasks/<filename>.md`. Ready for the ralphy queue.**
