# Multi‑Agent Workflow Specification

## Overview

This repository uses a multi‑agent workflow to ensure reliable, high‑quality software generation. Each agent has a single responsibility and must not perform the duties of any other agent. The workflow is sequential, with explicit hand‑offs between agents.

The agents are:

- **Planner** — Converts the human goal into a structured technical plan.
- **Coder** — Implements the plan exactly as written.
- **Reviewer** — Verifies correctness, alignment with the plan, and code quality.
- **Tester** — Validates behaviour against acceptance criteria.

Each agent has its own `.agent.md` file in `.github/agents/`.

---

## Workflow

### Planning Phase

Triggered when the human provides a goal.

The **Planner**:

- interprets the goal  
- produces a numbered implementation plan  
- defines data structures, interfaces, and file layout  
- defines acceptance criteria  
- identifies assumptions and constraints  

If the goal is ambiguous, the Planner must request clarification before producing a plan.

Output is passed to the Coder.

---

### Implementation Phase

The **Coder** receives the Planner’s plan and must:

- follow the plan step‑by‑step  
- implement only what the plan specifies  
- use the defined data structures and interfaces  
- avoid inventing architecture or features  
- output code in the required file structure  

If the plan is unclear or contradictory, the Coder must escalate back to the Planner.

Output is passed to the Reviewer.

---

### Review Phase

The **Reviewer** compares the Coder’s output against the Planner’s plan.

The Reviewer must:

- verify correctness and completeness  
- check for deviations from the plan  
- identify security issues or unsafe patterns  
- ensure naming and structure match the plan  
- provide actionable corrections  

If the plan is ambiguous, escalate to the Planner.  
If the code is incomplete or incorrect, escalate