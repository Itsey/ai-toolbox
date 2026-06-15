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

If you are unable to find versonify.config then prompt the user asking them for a version source location. A version source location can be a directory or a nexus url.  

## Versioning Language

Version numbers are made up of a series of digits, if the user askes you to update a digit they may do it by digit position ( e.g. first, second etc.) or they may use the following terms:

| Term     | Digit Position / How to identify |      |
| -------- | -------------------------------- | ---- |
| Major    | First digit                      |      |
| Minor    | Second Digit                     |      |
| Build    | Third Digit                      |      |
| Revision | Fourth Digit                     |      |



## Capabilities.

With this skill you can do several things related to versioning.  



### Version Source

Each of the commands takes a version source which you must already know as part of the pre-requisites.  replace `<versionsource>` in each of the commands below with the correct version source that you identified.

#### Finding the version source

Search the solution for a project that ends in .build, this is a nuke build solution. Look in build.cs for an instance of LocalBuildConfig.  This will last configuration for the build including one or more versioning tokens, each token will identify a version number.  If more than one is found then its likely one is a release version number and on is a pre-release, use the field names to work out which is which. 

If you have more than one version source for the commands you may need to ask the user which number they are working with.

#### List the current Version.

If the user asks for the current version or wants to know what the current version number is then this can be achieved by executing the versonify command as follows:

```
versonify Passive -v=<versionsource> 
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

Queuing an increment means that the next time that an increment is run then this number will be used instead of the regular increment process.  This should be used if the user asks to "set the version next time its run" or "queue up a version change" or anything like that.

There are two things that can be queued, a relative increment or a specific number.  

To queue a change you use the --quick-value parameter and provide a set of dot separated changes. For example

```` 
versonify override -q +.+.+.+
````

This would queue up an increment where the first four digits would all be incremented.

The increment options are:

A + symbol will increment the digit.
A - symbol will decrement the digit.
An integer will set the value of that digit to that integer value.

Therefore given the version number 1.2.3.4 applying +.-.1.1 to it would result in 2.1.1.1





#### Create a versonify configuration file  ( or mm file )

