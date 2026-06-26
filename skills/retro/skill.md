---
name: retro
description: End-of-session retrospective. Reviews the conversation for corrections, friction, and wasted effort, then proposes durable improvements to skills and rules. Use at end of sessions or when user says "retro", "start a retro", "run a retro". PROACTIVE - if the conversation has repeated corrections or mounting friction, suggest running /retro and restarting the session.
metadata:
  author: jim
  version: "2.0"
---

# Session Retrospective

Review the full conversation to find moments where the user corrected or redirected the AI. Turn correction signals into durable system improvements.

The goal: **make AI collaboration compound over time**. Every retro should leave the system better for the next session.

## Threshold Check

Before starting, assess the session. If it was a quick task (under ~5 substantive exchanges), say so and skip the retro unless the user insists.

## Phase 1: Detect Correction Signals

Read the entire conversation. Look for these signal types, ordered by value:

**HIGH confidence** — explicit corrections:

- "No", "that's wrong", "I said...", "don't do that", "not like that", "change that"
- User repeating an instruction the AI missed or ignored
- User pointing out an error or an omission — e.g. "now that is broken", "you now have this issue"
- User undoing or reverting something the AI did
- "Use X not Y", "always do X", "never do Y"

**MEDIUM confidence** — approved approaches:

- "Perfect", "exactly", "that's right", "yes, like that"
- Approaches the user explicitly validated (worth noting if they contradict a current rule or reveal an undocumented preference)

**LOW confidence** — observed patterns:

- Workarounds (user doing something manually the AI should have done)
- Wasted effort (AI went down a wrong path before being corrected)
- Friction points (things that took more back-and-forth than necessary)

**TOOL ERRORS** — failed tool calls:

- CLI commands with wrong subcommands, flags, or argument names
- API/MCP tool calls with wrong parameter names or shapes
- Tools called in the wrong order (missing required predecessor)
- Repeated failures where the AI retried the same broken call instead of fixing it
- For each error: note the wrong invocation AND the correct one

Skip one-off misunderstandings, simple typos, and things that are already documented in existing rules.

## Phase 2: Classify Improvements

For each signal worth capturing, determine the category:

| Category        | Description                                        | Example                                                    |
| --------------- | -------------------------------------------------- | ---------------------------------------------------------- |
| **Behavioural** | How the AI should work differently                 | "Ask one question at a time, don't batch"                  |
| **Guardrail**   | Hard rule to prevent a specific failure            | "Never call `git clean` without `-fd` flags"               |
| **Tech debt**   | Shortcut taken that should be fixed later          | "Hardcoded path needs extracting to config"                |
| **Backlog**     | Good idea that emerged but wasn't the current task | "Could automate X workflow as a skill"                     |

Tool errors are almost always **Guardrail** items — they produce a concrete "use X not Y" rule. Only Behavioural and Guardrail items get written to rules/skills. Tech debt and Backlog items are reported for the user to action separately.

## Phase 3: Map to Destinations

For each Behavioural or Guardrail item, determine where it belongs. Load all of the relevant skills, agents, and memory files that contributed to the session and identify the most suitable location. Choose the destination table for the AI in use.

### Claude Code destinations

| Pattern                                          | Destination                                                     |
| ------------------------------------------------ | --------------------------------------------------------------- |
| Applies to a specific skill                      | `skills/<name>/skill.md`                                        |
| Applies to a specific agent                      | `agents/<name>.agent.md`                                        |
| Applies to this project broadly                  | `CLAUDE.md` in the project root                                 |
| Applies to all of this user's sessions           | Global `~/.claude/CLAUDE.md`                                    |
| Is a durable preference or working-style note    | Memory file — `feedback` type in the project memory directory   |
| Captures project state, goals, or decisions      | Memory file — `project` type in the project memory directory    |

### GitHub Copilot destinations

| Pattern                            | Destination                                                |
| ---------------------------------- | ---------------------------------------------------------- |
| Applies to a specific skill        | That skill's skill.md (load `/skill` for format reference) |
| Applies to certain file types only | `.github/rules/*.md` with `paths:` frontmatter             |
| Applies to one project             | Project `copilot-instructions.md`                          |
| Applies universally                | Global `~/.github/copilot-instructions.md`                 |

**Specificity rule**: always store in the most specific location that applies. A lesson about the ralph skill goes in `skills/ralph/skill.md`, not in a global instructions file.

**Memory vs. skill/agent (Claude Code)**: If the correction is about *how the AI behaves in future sessions* (not tied to a specific skill's logic), write it as a `feedback` memory. If it changes the logic of a specific skill or agent, edit that file directly.

## Phase 4: Present Findings

Present all findings in a single table for review:

| #  | Signal                                              | Category    | Proposed rule                                              | Destination                       |
| -- | --------------------------------------------------- | ----------- | ---------------------------------------------------------- | --------------------------------- |
| 1  | AI edited the ralph skill instead of the coder agent | Guardrail   | Coding preferences live in `coder.agent.md`, not ralph     | `skills/ralph/skill.md`           |
| 2  | Planner produced plan before reading the codebase   | Behavioural | Planner must read codebase before writing any plan section | `agents/planner.agent.md`         |
| 3  | Auth helper was duplicated instead of shared        | Tech debt   | _(report only)_                                            | —                                 |
| 4  | User confirmed: one task per commit is correct      | Behavioural | No intermediate commits — single commit at mark-done       | Memory (feedback)                 |

**Golden rule: NEVER store user input verbatim. ALWAYS synthesise into an actionable, reusable rule.** Write the instruction the AI needs to follow, not a narrative of what happened.

**Depth rule: describe the underlying construct, not just surface examples.** Surface-level examples are easy to pattern-match around with minor rephrasing. Name the deeper grammatical or structural construct. This makes the rule robust against novel phrasings of the same anti-pattern.

Bad: "User said not to use feature branches"
Good: "Ralph uses trunk-based development — commit directly to the current branch, never create a feature branch"

Bad: "User pointed out a failed unit test"
Good: "After any code change, run the full test suite before reporting completion"

Bad: "Don't write 'Not a curated demo, but the full picture'"
Good: "Avoid appositive negation — defining something by what it is not before stating what it is. Just state what it IS."

Wait for user approval before proceeding. The user may reject, modify, or re-categorise items.

## Phase 5: Apply Approved Changes

For each approved item:

1. Read the target file
2. Check the proposed rule doesn't already exist (in this file or a higher-priority location)
3. Find the right section or create one
4. Write the rule — concise, imperative, no narrative

For memory items, write to the correct memory file using the standard memory format (frontmatter with name, description, type; body with the rule, a **Why:** line, and a **How to apply:** line). Update `MEMORY.md` with a pointer.

## Phase 6: Verify

After all changes:

- Read each modified file to confirm no duplication or contradiction was introduced
- Confirm any new memory entries are indexed in `MEMORY.md`
- Report a summary of what was updated and where

## What NOT to Capture

- Things that already worked (no rule needed for correct behaviour)
- Session-specific facts ("user was working on the spec skill today")
- Speculative improvements not backed by actual friction in THIS conversation
- Anything that duplicates existing instructions
- One-time fixes or typo corrections
- Generic best practices the AI should already know

## Integration

This skill reads and writes:

- **`skills/*/skill.md`** — skill files for skill-specific corrections
- **`agents/*.agent.md`** — agent files for agent-specific corrections
- **`CLAUDE.md`** — project-wide rules
- **`~/.claude/projects/.../memory/`** — durable feedback, user, and project memories
- **`MEMORY.md`** — memory index (update whenever a memory file is written)
