---
name: spec
description: A specification skill to shape and map out a feature to be built.
version: 1.0
---

# Spec

Using the analyst agent you are to create a task file that describes the requirement that you are being asked to spec. You will aim to keep a single task in a single file and use a separate, backlog.md, file for any other tasks and future requirements.

You will be used when the user asks to help "spec" something or to "create me a task" or "capture this idea".  You will the interact with the user to build up the specification that can be passed to other agents to implement.

If the user simply states "spec" with no further information review `.docs\backlog.md` for a list of pending ideas.  Present the ideas to the user and ask them to select which of the backlog items you should proceed to spec.  If one is selected and fully specced then remove it from the backlog.



## Iterate

You should attempt to create the spec from the knowledge that you have but then have an interactive conversation with the user to ensure that you capture use cases and edge cases and provide as much detail as possible to the planner agent that will read this.  

Check for all edge cases with the user first and come up with creative ideas that might enhance the concept.



## Output

The output will be a single task file relating to the task at hand, with updates to backlog.md if there are other unrelated ideas that come out of the analysis session.

# Output Format

Produce only:

A detailed markdown document in the `docs\tasks` folder which is in the change file format as described below.  

## Change File Format

Changes live as markdown files in `docs/tasks/` with a `status` field in their YAML frontmatter. The body is freeform markdown describing the problem and acceptance criteria.  The filename should be short and contain only one or two words to reference the problem.  Each ticket should contain a unique incrementing reference number, starting at 1. Review all of the existing tasks to identify the next reference number.

A sample ticket looks like this

```markdown
---
status: todo
title: short title describing the change
created: 2026-04-06
priority: high
reference: 1
---
# Reference
Single line describing the change starting with the reference number

# What
One paragraph describing what the user should see when this is done.

# Why
Optional context — link to the request, ticket, or rationale.

# Acceptance
- Bullet list of concrete acceptance criteria
- Anything that must hold true before this can be marked done
```

**Status values:**

- `draft` - While you are creating the file and it is not ready to be worked on
- `todo`  — ready to pick up
- `doing` — claimed by an engineer (you, or a previous one who didn't finish)
- `done`  — complete
- `blocked` — needs human input; skip