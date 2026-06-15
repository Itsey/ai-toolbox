---
name: markmyhomework
description: Performs a final review on code that has been coded to a specification and is ready for release, checking for correctness and recommendations.
---
# Final Review Skill

This skill is to perform a final review on code that has been coded to a specification and is ready for release. You are to perform the final review for correctness and make a series of recommendations based on your findings.



## Identify The Task.

In the docs folder will be a task that is in the state of `coded` this can be identified by looking in the `docs\tasks\` folder and reviewing the md documents.  In the front matter there is a `status` field which identifies the status.  

There should only be one task that has the status of coded.  If there is more than one then exit this process and notify the user of the issue.

Once you have identified the task read it and understand the task. 



## Review The Code

The code will be in the `.\src` folder you should review the entire codebase and get a good feel for the standards and approaches used there.  Review the uncommitted changes against the specification that you found from the task.   You are only to review the uncommitted code - but use the full code base for context.

Check for the following things:

* Does the new code correctly implement every element of the task specification?
* Are there any security / performance or best practice issues with the new code?
* Does the new code enhance the test coverage position of the code base
* Are all coding standards met - including adherence to everything in .editorconfig
* Check that all new tests are Snake_cased and groups of 3 or more related tests are in nested classes describing the group.
* Ensure that there are no warnings such as IDE0007, IDE0006



## Determine if the implementation is successful

If the brief has been met then the implementation is a success.  Mark the task as `done`.  

## Prepare a report for the user.

Prepare a report for the user - summarise any issues found and prepare a statement that indicates whether the brief of the task was met or not.  Provide details for any issues found including why it might be an issue and what your recommendation would be.  Provide the statement first then a numbered list of any issues found with a recommendation as to whether the issue is a must-fix or a nice to have.  Follow that with the details regarding why each issue is a concern and what the proposed fix might be.

The statement and numbered list should be available in the console immediately, and the user can ask for details of the remainder.



## Identify Improvements To The Agents

If you found issues or recommendations then review the task itself and additionally the agent files in this directory `X:\Code\ghub\ai-toolbox\agents` identify where would be the best place to make amendments such that the issues that you identified would not have occurred.    Propose those changes back to the user with an explanation as to how it would prevent reoccurrence.

If you are asked to "update the agents" or any statement like that then go ahead and update those agent files with your recommended changes.

