---
name: goodlittledev
description: A healtcheck skill for repositories on disk to determine if they are in the correct state
version: 1.1
contact: jim
---

# GoodLittleDev

This skill checks for standard practices across multiple repositories.



## Prerequisites

Locate the file `~\gld.config` if it is not present then use the following approach to create the file.  

The file is a json configuration file with the following settings:

Ask the user for one or more repository locations.  These will be added to an array of strings in the config file called repobasepaths.  

Ask the user if they are using primary files, and if they are then whether it is a disk or nexus path.  If it is a disk path they should provide the folder that the primary  files are in.  If they are using nexus then ask for a server path, port,username and password.  Create a primaryfiles element in the config file, add the relevant details.

If the file exists then assume that it is correct and proceed to the preparation.



## Preparation

If there is a primary files section in the configuration file retrieve the primary files.

Use the following commands to download from nexus the common files:

```
curl -u <username>:<password> -L -O "<nexusserver>/repository/plisky/primaryfiles/default/common.gitignore"
curl -u <username>:<password> -L -O "<nexusserver>/repository/plisky/primaryfiles/default/common.editorconfig"
curl -u <username>:<password> -L -O "<nexusserver>/repository/plisky/primaryfiles/default/common.nuget.config"  
```

These are the common files that are to be used for comparison.



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

#### Common File Check

Prior to starting the common file check, look for readme.md in the repository root.  If it is there check for information for "goodlittledev" - if a repository is configured in a non standard way then this information overrides the default rules in this skill.  This will include telling you how to compare the files or if the files should not be compared at all.  

For each of the common files that you are to check locate them by starting your search in the repository root.  If the file is not located there then check in the src folder or any folder that starts with src.  If it is not located then check one level down again, looking in each of the folders under src or starting with src.  If more than one file is found of a type then always use the highest one in the hierarchy.



* Locate a  `.gitignore` file, and compare it against the primary `common.gitignore` file that you downloaded.
* Locate  a `nuget.config` file and compare it against against the primary `common.nuget.config` 
* Locate a `.editorconfig`  file and compare it against against `common.editorconfig` 



If any of these do not match then the common files status is "outdated", if they all match then the common files status is "correct".  If the status is "outdated" then indicate which files are correct using the following notation.   

* `.gitignore` should be abbreviated to `.gi` with ❌for out of sync and ✅for the same.  If the file is not present use 🗑️
* `.editorconfig` should be abbreviated to `.ec` with ❌for out of sync and ✅for the same. If the file is not present use 🗑️
* `nuget.config` should be abbreviated to `ngt` with ❌for out of sync and ✅for the same.  If the file is not present use 🗑️

This info should be included in the common files column.

If good little dev instructions note a file as an exception use this icon ❕



### Offer To Correct.

Allow the user to review the report.  Once they have had a chance to review the report the proceed with offer to correct.

For any repositories which are "fine" but have out dated common files offer to fix them.  You can fix out of sync or missing files, but not the ones that are exceptions.  You should only fix in repositories which are "fine".   Always ask the user if they want the fix applied.  If they say no then take no further action.

If they agree then proceed:

* If there is an out of date `.gitignore` file, then replace it with the contents of the `common.gitignore` file that you downloaded.  If it is missing place it in the root of the repository.
* If there is an out of date  `nuget.config` file, then replace it with the contents of the primary `common.nuget.config` that you downloaded.  If it is missing locate a src directory and place it in there.  If there is no src directory take no action.
* If there is an out of date `.editorconfig`  file, then replace it with the contents of the primary `common.editorconfig` that you downloaded. If it is missing locate a src directory and place it in there.  If there is no src directory take no action.



For any repository that you have made changes commit those changes, ensuring only that the primary files are in the commit.  Use the message "Auto correct out of date primary files (ai)".  Push the changes.  Update the report to change the current status to (fixed).
