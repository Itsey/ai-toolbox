---
name: versonify
description: A versioning skill that uses the versonify command line tooling to manage version numbers.
version: 1.0
contact: jim
---

# Versonify

This skill works with the versonify.exe command line too to manage versions and version numbers.  It can be used to create a new version number or apply versioning to the solution.  



### Prerequisite

The command versonify should be available to use this skill.  If it is not then it should be installed as a global tool from Nuget by running a dotnet global tool install command for the package `plisky.versonify`.  If you are unable to install the tool then do not proceed but instead notify the user that without versonify this skill can not proceed.  Highlight any errors that were caused when trying to install the tool.

There will also need to be a version store.  The version store will either be a nexus raw repository or a disk path.  At start of this skill check for a file called versonfiy.config in the solution directories.  It can be at any location so glob for it within the repository structure.



## Capabilities.

With this skill you can do several things related to versioning.  Each of the commands takes a version source which you must already know as part of the pre-requisites.  replace `<versionsource>` in each of the commands below with the correct version source that you identified.



#### List the current Version.

If the user asks for the current version or wants to know what the current version number is then this can be achieved by executing the versonify command as follows:

```
versonify 
```

#### Set the current version

```cmd
versonify
```



#### Create a new version

```cmd
versonify CreateVersion  -vs=<versionsource>
```



#### Increment the current version



#### Queue an increment for the current version



#### Create a versonify configuration file  ( or mm file )

