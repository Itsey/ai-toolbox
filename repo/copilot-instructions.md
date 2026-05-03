# Copilot Instructions for Code Suggestions

These rules should be followed by github inline code editor and github copilot chat.

- **Modernity:** Use modern technologies and best practices relevant to the programming language and framework in use.
- **Rationale:** If a code suggestion involves a significant change, provide a detailed explanation of the rationale behind the change.
- **Constants:** Avoid using magic numbers; use constants or enums instead.
- **Whitespace:** Don't suggest whitespace changes.
- **Modularity & Maintainability:** Encourage modular design, maintainability, and reusability; follow DRY (Do Not Repeat Yourself) principle.
- **Explicitness:** Only implement changes explicitly requested.
- **Testing:** Suggest or include unit tests for new or modified code, covering edge cases and error handling.
- **Comments:** Use comments sparingly and only when meaningful.
- **Verification:** Always ensure that the code compiles and passes existing tests after your changes.

### Making Edits

- **Change Management:** Focus on one conceptual change at a time and show clear before/after snippets.
- **Relevance:** Only change code that is directly relevant to the task at hand. Do not refactor unrelated code unless it is necessary for the change.

### Instructions for Code Generation.

- Only generate a plan if you need it for the task at hand. If you do not need a plan then do not generate one.  
- Focus on solving the task at hand. Once you have finished the task, review all the code in any modified files and identify security issues or code quality issues. If you find any issues then suggest a prompt that
  would fix the issues. If you do not find any issues then state that no issues were found.

## Test Project Requirements

- **Integration:** .ITest projects are Integration Tests.  Tests which require external resources, such as databases or file systems, should be placed in an .ITest project.

## Repo Specific Requirements

- **Library:** The Plisky.Versioning project is a reusable library with the versioning logic.
- **CLI:** The Versonify project is a user-facing dotnet CLI tool to interact with the versioning system.  The Versonify project should reference the Plisky.Versioning project to access the core versioning logic. Command line interface and output should be within the Versonify project.
- **CoreLogic:** Core logic should be added to the Plisky.Versioning project where it can then be referenced by the Versonify project.