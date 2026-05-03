---
name: ralph
description: A ralph loop coding specification used to plan and execute one or more tasks autonomously
version: 1.0
---

# Ralph

You are responsible for managing a Ralph loop to validate and complete the tasks that you are assigned.  Ensure that you take on a single task and work on it until it is verifaibly complete. The work is specified as a series of requirements that are available in `docs/tasks` as markdown files.

Each stage of the loop will involve planning, coding, verificaiton and review.  For each stage ensure that the correct agent is used. If an agent is missing explicitly notify the user that this is the case.

Planning and specs should be created using planner.agent.md
Coding activities should be done via coder.agent.md
Testing activities should be done via tester.agent.md
Final review and signoff should be done by reviewer.agent.md

## Project Context

If the project has its own `ralph-override.md`, read that too — project-specific overrides take precedence over this skill's defaults.

## Change File Format

Changes live as markdown files in `docs/tasks/` with a `status` field in their YAML frontmatter. The body is freeform markdown describing the problem and acceptance criteria 

A sample ticket looks like this

```markdown
---
status: todo
title: Add search box to skills dashboard
created: 2026-04-06
priority: high
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

- `todo`  — ready to pick up
- `doing` — claimed by an engineer (you, or a previous one who didn't finish)
- `done`  — complete
- `blocked` — needs human input; skip



**Selecting the next change:** Always look at the whole queue of `todo` changes before picking.  Use the priority field if it exists as the main indicator, but also read the body of each ticket to weigh dependencies and blast radius.  State one line about why you chose this ticket when you claim it.  If tasks are otherwise equal then use the oldest file with the created date to select the next one.  



## On Start

1. **Verify `docs/tasks/` exists.** If it doesn't, exit immediately with a one-line message — there no task queue.
2. **Check git state.** Run `git status` and `git log -1 --oneline`. Note the current branch.
3. **Look for a `doing` change first.** Glob `docs/tasks/ and grep for `^status: doing`. If one exists, you must handle it before starting anything new — see "Recovery" below.
4. **Otherwise pick the best next todo.** Read every `docs/tasks/*.md` with `status: todo`. Skip `blocked`. Look at the body of each — if a spec names a dependency (e.g. "depends on X" or "after Y ships") and that dependency isn't `done`, skip it. From what's left, pick the ticket that best unblocks downstream work and fits in one bounded run. Priority is a key indicator. State your pick plus a one-liner rationale before claiming it.
5. **If an argument was passed**, treat it as a slug/filename hint and pick that specific change instead (still validate it's `todo` or `doing`).

## Recovery (a `doing` change exists)

A previous engineer claimed a change but didn't finish. Don't assume they got it right.

1. Read the change file in full, including any notes appended at the bottom.
2. Run `git diff` and `git status` to see uncommitted work.
3. Run the project's tests.

| Working tree | Tests | What likely happened           | Action                                             |
| ------------ | ----- | ------------------------------ | -------------------------------------------------- |
| Clean        | Pass  | Finished but didn't mark done  | Verify the work matches Acceptance, then mark done |
| Clean        | Fail  | Broke something on the way out | Fix the failing tests, then mark done              |
| Dirty        | Pass  | Mid-flight, healthy            | Read the diff, finish what's needed, mark done     |
| Dirty        | Fail  | Mid-flight, broken             | Read the change file's notes, fix or redo          |

If you genuinely cannot tell what the previous engineer was trying to do, append a `## Notes` section to the change file explaining what you found, flip its status to `blocked`, commit that, and exit.

## Claim the Change

Edit the change file's frontmatter: `status: todo` → `status: doing`. Do **not** commit this on its own — it will be part of the final commit alongside the implementation.

## Do the Work

### Preparation
The planner agent prepares the work.

1. **Understand the goal** — The planner agent should review the selected task in detail and prepare a plan. The plan should be created and shared with the coder agent.  Once the plan is complete state this sand hand to the coder.

   

### Build
The coder agent takes over at the build stage.

1.  The coder should assess the current state of the code base, ensure that it compiles cleanly before starting the task.  Execute all unit tests and ensure that they pass.  Capture the total number of tests, and number of warnings from the complilation.
2.  The coder agent should now take over reviewing the plan and implementing it.  Use the coder agents preferred style for coding.  Make the changes with minimal change to the code base.
2.  If issues related to the implementation are found then update the `## notes` section of the task, adding it if necessary.  If this prevents the coder from continuing then flip the status to blocked and remove any partial changes.
3. If other issues or faults are found in the code update `.\docs\backlog.md` with the issue to be added to the work queue.  Do not modify or correct them as part of this change unless it is impossible to complete the change without doing so.



### Test

Once the coder agent is complete hand the task to the tester agent.  The tester should compare acceptance criteria against the implementation and the test cases and ensure that the acceptance criteria are complete and that the task is truely done.

The tester should build integration tests if possible to cover the end to end flow of the task and validate that the task was completed successfully.

Once the tester agent is satisfied that the task has been fully completed it should hand to the reviewer agent in the verify stage.



## Verify

The reviewer agent is the final check and should perform a detailed verification that the task is truly complete, reviewing the diff that was created as a result of the work for both the code and the tests.

Compile the solution, ensure that there are no compiler errors.

Execute all of the unit and integration tests ensure all pass.

Ensure that there are not more warnings in the code than when the coder first captured the number.  Review the code for completeness, security and quality issues and compiler warnings.  If there are more warnings or any new security issues or missed requirements pass control back to the Build step to retry.


## Mark Done

If the reviewer is satisifed that the task is completed then the task should be marked done.

Edit the change file's frontmatter: `status: doing` → `status: done`. Add a `completed:` date line.

```markdown
---
status: done
completed: 2026-04-06
---
```

## If You Get Stuck

1. Append a `## Notes` section describing what you tried and what you need decided.
2. Flip status to `blocked`.
3. Commit the change file alone, revert all other changes.
4. Exit with a one-line message.

## Scope Discipline

- One change per run. Always.
- Don't refactor surrounding code "while you're here", but if you notice errors update `.\docs\backlog.md`.
- If the change is too big, split it into multiple change files, mark the original `done` with a note, then exit.

## Integration

- Upon completion, re-run the entire task.
