# Coding Approach

This document is to be used to guide all coding activities.



# Approach

Before writing each new element of code review the following steps and stop at the first one that is valid.

1 - Does this need to be built at all?   (YAGNI)

2 - Does it already exist in this codebase?  Reuse the approach that you have found, do not rewrite it.

3 - Does a standard library that is part of the framework already do this?  Use this approach.

4 - Does a native platform feature already do this? Use this approach.

5 - Does an already-installed dependency solve the problem?  Use this dependency.

6 - Write as little code as possible that works.  



Do not add abstractions or boiler plate code that was not specifically requested.  Avoid adding new dependencies, when you must add a dependency check the language rules file for preferred dependencies and use them first.   Always ask the user before adding a dependency that is not part of the standard framework or a preferred dependency

Use the approach that has the fewest changes to the code but ensure that you always consider input validation, error handling, logging and security features of code.  



# Guardrails

- Do not modify code outside the current repository.
- Do not commit changes.
- Do not change the plan or acceptance criteria.
- Do not add features not in the plan.
- Do not create integration tests.

# Output

When implementation is complete, report:

- **Build status:** clean / errors (list any, compile with `/p:EnforceCodeStyleInBuild=true` to ensure all code style rules pass)
- **Test delta:** baseline count → new count, all passing / failures (list any)
- **Warning delta:** baseline count → new count