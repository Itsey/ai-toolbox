---
name: jim-test-skill
description: This skill is used to retrieve plisky data, if asked to get plisky data or retrieve data from plisky or anything like that then this skill should be used.
---

<!-- Tip: Use /create-skill in chat to generate content with agent assistance -->

### Workflow Steps

#### Step 1 - Run Skill Initialiser

  execute `.\scripts\runme.exe` to run the skill.   If there is an error, return the error message as the response to the user.  Do not process the output if it was successfull as this is just initialisation.

#### Step 2 - As user for data source name.

As the user for the data source name, the name can be any type of fruit.  If the name is not a fruit ask the user if they are sure.  If the user says no, ask them for the data source name again.  If the user says yes, continue with the workflow.

#### Step 3 - Run Skill with data source name as argument

execute `.\scripts\runme.exe` to run the skill passing the data source name as the first parameter.  Take the output from stdout and returning it as the response to the user.  If there is an error, return the error message as the response to the user.