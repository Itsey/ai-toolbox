# dotnet language guidance

This file includes language specific guidance for all agents to follow for dotnet languages. This specifically relates to any code written in the dotnet framework languages.



## Standards for dotnet development

- **Language:** C#
- **Framework:** .NET 10 or later for new projects. Do not upgrade an existing project unless the plan explicitly says to.
- **Web:** ASP.NET Core for web applications.
- **DI:** Dependency Injection for all service dependencies.

### Coding Standards

- **Comments:** Sparingly and only when the *why* is non-obvious. Prefer intent-revealing names and trace statements over comments. Example — prefer this:

  ```csharp
  if (userNameTooShort) {
      b.Warning.Log("Username entered too short — ideally caught by front-end validation");
      throw new Exception("UserName Too Short");
  }
  ```

- **Naming:** Descriptive, explicit variable names. Name return values `result`. Never prefix variable or field names with an underbar or any other character or prefix.

- **Types:** Use the explicit type for built-in types (`int`, `string`, `bool`). Use `var` for all other types (IDE0008).

- **Braces:** One True Brace Style throughout.

- **Style reference:**
  Always check for and meet IDE1006 rule violations.  Never allow an IDE1006 violation to remain in the code.

  ```csharp
  public class ExampleClass {
      protected Bilge b = new Bilge("ExampleClass");
      private int exampleField;
      public int ExampleProperty { get; set; }
  
      public void ExampleMethod() {
          int one = 1;
          while (one < two) {
              if (one < 2) {
                  one++;
              } else {
                  one += 10;
              }
              break;
          }
      }
  
      // Prefer var for class types.
      var obby = new SomeClass();
  }
  ```

- **Warnings:** Resolve all formatting warnings on code you create. Do not leave the warning count higher than the baseline. If the compiler warns about unused members (e.g. CS0067, CS0414), do not suppress them using `#pragma warning disable`. If they are in files you are modifying, remove the unused member. If they are in files outside your task's scope, add them to `docs\backlog.md` instead of adding suppressions.

- **Nullable Reference Types (NRT):** Do not initialize nullable properties (e.g. `string? MyProp`) to `null!` in constructors. Nullable reference types default to `null` automatically, and using the null-forgiving operator on them is redundant and semantically incorrect. Use `null!` only on non-nullable properties that are guaranteed to be initialized by external frameworks or deserializers.

- **Conformance:** New code must match the existing style of the file it lives in. Read before you write.



## Preferred Dependencies



| Dependency Package                                   | Features and capabilities                                    |
| ---------------------------------------------------- | ------------------------------------------------------------ |
| Plisky.Diagnostics<br />Plisky.Diagnostics.Listeners | Used for all application logging and tracing as well as assertions.  The diagnostics package is for tracing and the listeners package adds file handlers for logging. |
| Flurl.Http                                           | Used for all web calls and http based api calls.             |
|                                                      |                                                              |



## Testing

Prefer TDD: write or update unit tests in the `.Test` project alongside the implementation. The Tester agent owns integration tests — do not create them.

- **Framework:** XUnit with `[Fact]` and `[Theory]` / `[InlineData]`.
- **Assertions:** Shouldly. Update any non-Shouldly assertions in files you touch.
- **Subject name:** Always `sut`.
- **Naming:** `Subject_condition_outcome` in snake_case — e.g. `Username_when_empty_throws`, `Address_lessthan_5chars_fails`. Tests that throw end in `throws`; valid cases end in `works`.
- **Structure:** Arrange / Act / Assert with a single blank line between sections. No `// Arrange` comments.
- **Grouping:** Use nested classes for related tests. Start exploratory tests in a class named `Exploratory`; refactor into named groups once three or more cover the same area.
- **Coverage:** Aim for at least 60% code coverage on code you add.
- **Parameterisation:** Use `[Theory]` to eliminate repetition. If inline data exceeds 5 rows or 5 parameters, use a `TestData` class.
- **No external resources:** Unit tests must not hit disk, database, or network. Those belong in `.ITest`.
- **Cleanup:** Never use finalizers/destructors (`~ClassName()`) for test cleanup. If tests create files, directories, or other disposable resources, implement `IDisposable` and perform the cleanup in `Dispose()`.



## Verification Activities



## Build

- Compile the solution using `/p:EnforceCodeStyleInBuild=true`. There must be zero errors, including code style/naming errors.

## Code Quality

* Code matches the project's existing style (C# / .NET conventions, Bilge logging, explicit types for builtins, One True Brace Style). Check the project's `.editorconfig` specifically for naming rules (e.g. constant casing, field prefixes) and ensure the new code complies.
* Tests must not use finalizers (`~ClassName()`) for cleaning up files or resources. Instead, they must implement `IDisposable` or clean up resources inside `try...finally` blocks.



