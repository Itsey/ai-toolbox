---
name: goodlittledev
description: A healtcheck skill for repositories on disk to determine if they are in the correct state
metadata:
  author: jim
  version: "1.1"
---

# GoodLittleDev

This skill checks for standard practices at strategic points.  Good Little Dev will try and work out what to do as a skill but will check if not sure.



## Prerequisites

Locate the file `~\gld\gld.config` if it is not present then check whether `~\gld.config` is present. If it is move it into `~\gld\gld.config` if the file still is not found then use the following approach to create the file:

The file is a json configuration file with the following settings:

Tell the user that no gld.config is found and that we will need to supply some information to proceed.

Ask the user for one or more repository locations.  These will be added to an array of strings in the config file called repobasepaths.  Explain to the user that they should enter one or more parent folders, within which are all of the repository folders that they regularly use.  

Ask the user if they are using mollycoddle.    If they are then request a PrimaryFilesPath and a RulesPath and a version name.  The version name may default to `default` if not supplied by the user.  Store the PrimaryFilesPath, the RulesPath and the version name in a mollycoddle section of the gld.config file.

If the file exists then assume that it is correct and proceed to the preparation.

Notify the user that setup is complete and that the skill can run in precommit mode or multirepository mode. 

## Preparation

If there is a mollycoddle section in the configuration file check that you can execute mollycoddle.  Use `dotnet tool list -g` to determine if `plisky.mollycoddle` is installed.  If is not then execute a dotnet global tool install to install it.



## Activities

This skill can either run in pre-commit mode or multi repo mode.  If either mode is specified in the call to the command use that.  If not use the following logic:  

* If the current folder is a repository where there are uncommitted files then it should default to pre-commit mode.
* If the current folder is not a repository then it should default to multi repo mode.
* If not sure ask the user.



## Pre-Commit (or precommit) Mode

You are to run a check prior to a commit happening to check for any issues.  These are the stages for the default check but the user may ask you to skip some of the checks.

* Check for a clean compile, in Debug and Release mode.
* Check that all unit tests run.
* Perform a git `fetch` and ensure that there are no changes in the remote. If the `fetch` identified new changes warn the user in the report, stash all local changes, perform a `pull`.  If it is possible to unstash without creating a merge then un-stash local changes and tell the user specifically if there were any changes to files that have modifications.
* Look for any compiler warnings in the changed files and specifically call out whether any of the new warnings have been introduced by the code changes.  If there are existing warnings flag those too.
* Check that all of the line endings are consistent CRLF line endings on all of the changed files.
* Look for any hard coded credentials or secrets in the files that are changed. If there are credentials in a modified file and that file is a configuration file such as app.config or web.config then git `stash` the changes to the file in a stash called `local changes stached prior to commit`



**Code formatting check:**

Run the following formatting commands on each file that has changed, using the project name for the project where the file has changed.  For the jb command use the solution name and a relative path from the solution to the filename to include.

Check for a `<solutionname>.dotsettings` file before running.  If it is not present warn the user that the JB cleanup wont work.

````
dotnet format analyzers <projectname> --include <filename>
jb cleaupcode <solutionname> --include=<filename> --profile=plisky
````



**Mollycoddle Check.**

If this is the first run of the session perform the mollycoddle check as below. There is no need to repeat this for repeated runs.



**Commit Message Report:**

Generate a summary report in the chat highlighting as warnings ⚠️ any new issues introduced and as ❗errors any compiler errors or failing unit tests.  Highlight for info ℹ️ any other warnings in changed files.

Give a quick summary of the changes that are made too for the commit message. Keep the summary short and factual in bullet point form, just highlighting what has changed.  



## Multi Repo Mode

Multi Repo mode runs a series of checks across multiple repositories - use the following sequence:



## Checks

To execute the checks, you MUST run the automated PowerShell script located in the skill's scripts directory:

```powershell
powershell -ExecutionPolicy Bypass -File "./scripts/generate_final_report.ps1" -ArtifactPath "<current-conversation-artifact-dir>/goodlittledev_report.md"
```

Replace `<current-conversation-artifact-dir>` with the current conversation's artifact directory (e.g., `~/.gemini/antigravity-cli/brain/<conversation-id>`).

The script automatically performs all of the Git status checks and common file comparisons specified below, and writes the output directly to the specified `goodlittledev_report.md` artifact.

The generated report will contain the following information, where the first line is provided as an example:

| Repo Name    | Current Status | Common Files             | Reference | Full Path            |
| ------------ | -------------- | ------------------------ | --------- | -------------------- |
| example-repo | fine           | outdated .gi❌ .ec✅ .ngt✅ | 1         | x:\code\example-repo |
|              |                |                          |           |                      |
|              |                |                          |           |                      |

You can use the script's output to compile the information, which is gathered using the following rules.

The reference is a straight forward sequential integer number starting at 1.

#### Git status check

In each subdirectory, check first that it is a git repository, then determine whether the repository is up to date.  If the repository has no local changes but is behind the origin then perform a pull.  If this brings the repository up to date then the status is "fine".

If there are uncommitted or un-pushed local changes then the status is "dirty".

If the local branch is not the default origin branch then the status is "adrift".



### Mollycoddle Check

Prior to starting the mollycoddle check, look for readme.md in the repository root.  If it is there check for information for "goodlittledev" - if a repository is configured in a non standard way then this information overrides the default rules in this skill.  This will include telling you how to compare the files or if the files should not be compared at all.  If this file specifies a version then replace the `default` version in the command with the one from the readme.

Using a working directory of the parent of the git repository execute a mollycoddle check using the following command.

```
mollycoddle.exe <directoryname> -rulesfile="<rulesfilepath>" -primaryroot="<primaryfilespath>" -addruleshelp -version=default
```

Mollycoddle will return a list of violations or say that there is a pass.





### Offer To Correct.

Allow the user to review the report.  Once they have had a chance to review the report the proceed with offer to correct.

For any repositories which are "fine" but have out dated common files offer to fix them.  You can fix out of sync or missing files, but not the ones that are exceptions.  You should only fix in repositories which are "fine".   Always ask the user if they want the fix applied.  If they say no then take no further action.

If they agree then proceed:

* If there is an out of date `.gitignore` file, then replace it with the contents of the `common.gitignore` file that you downloaded.  If it is missing place it in the root of the repository.
* If there is an out of date  `nuget.config` file, then replace it with the contents of the primary `common.nuget.config` that you downloaded.  If it is missing locate a src directory and place it in there.  If there is no src directory take no action.
* If there is an out of date `.editorconfig`  file, then replace it with the contents of the primary `common.editorconfig` that you downloaded. If it is missing locate a src directory and place it in there.  If there is no src directory take no action.
* If there is a missing `<solution>.sln.dotsettings` file copy the common.sln.dotsettings file and rename common to be the solution name.  Ensure that this is repeated for each solution in the directory.



For any repository that you have made changes commit those changes, ensuring only that the primary files are in the commit.  Use the message "Auto correct out of date primary files (ai)".  Push the changes.  Update the report to change the current status to (fixed).
