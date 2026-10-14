---
name: versonify
description: A versioning skill to support the use of versonify.  Start with describe my versioning.
metadata:
  author: jim
  version: "1.1"
---

# Versonify

This skill works with the versonify.exe command line too to manage versions and version numbers.  It can be used to create a new version number or apply versioning to the solution.  



### Prerequisite

The command versonify should be available to use this skill.  If it is not then it should be installed as a global tool from Nuget by running a dotnet global tool install command for the package `plisky.versonify`.  If you are unable to install the tool then do not proceed but instead notify the user that without versonify this skill can not proceed.  Highlight any errors that were caused when trying to install the tool.

Execute the command `versonify.exe --qqpnf` and identify the exit code.  This should be 201 or greater.  The exit code 201 indicates that it is a compatible with this skill. If an exit code of less than 201 is returned notify the user that they must update versonify and the skill.

  

## Versioning Language

Version numbers are made up of a series of digits, if the user askes you to update a digit they may do it by digit position ( e.g. first, second etc.) or they may use the following terms:

| Term     | Digit Position / How to identify |      |
| -------- | -------------------------------- | ---- |
| Major    | First digit                      |      |
| Minor    | Second Digit                     |      |
| Build    | Third Digit                      |      |
| Revision | Fourth Digit                     |      |



## Configuration

When working in a repository attempt to identify the configuration that applies.

* Look for a configuration file - it will be a file that ends in `.vsets` and will be either in a _Dependencies directory or with the source code.  If this file is present then this is the primary form of configuration. 

* If the configuration file is not present then fall back to identifying the configuration from the code using the following steps:

  * Look for a text file which holds a series of File Update statements ( refer to the section below on File Update statements files to help identify the file).  This will list all of the files that are updated.

  * Search the solution for a project that ends in .build, this is a nuke build solution. Look in build.cs for an instance of LocalBuildConfig.  This will last configuration for the build including one or more versioning tokens, each token will identify a version number.  If more than one is found then its likely one is a release version number and on is a pre-release, use the field names to work out which is which. 

    If you have more than one version source for the commands you may need to ask the user which number they are working with. Search the solution for a project that ends in .build, this is a nuke build solution. Look in build.cs for an instance of LocalBuildConfig.  This will last configuration for the build including one or more versioning tokens, each token will identify a version number.  If more than one is found then its likely one is a release version number and on is a pre-release, use the field names to work out which is which. 
  
* Identify if more than one version store is used.  Search in the configuration or nuke configuration to identify if more than one version store is used.  This will usually be a legacy mode of working, if this is found review the upgrade section below. 

* If either more than one digit file is found or the configuration file is not found the its likely that this is a legacy configuration, offer to upgrade the versonify configuration.



If you have more than one version source for the commands you may need to ask the user which number they are working with.

​    



## Capabilities.

With this skill you can do several things related to versioning.  The versioning activities rely on a tool called versonify.  Whenever you are executing the tool `versonify` then add the output specifier `-o=jcon` this will write out json formatted output to stdout and stderr to help make the output more explicit.  

The json formatted output has a `messagecategory` identifier to inform you of the type of messages with the following types:

* `information` textual information about the activities
* `result` the final result including any version number.
* `error` an error in processing with an `errorid` in the meta key values.



### Version Source

Each of the commands takes a version source which you must already know as part of the pre-requisites.  replace `<versionsource>` in each of the commands below with the correct version source that you identified.

#### Describe Versioning

If you are asked to describe the versioning setup for a project or explain the versioning then you should follow the following steps.

* Identify how versioning is configured.  



Create a short paragraph describing the configuration and then list:

The version store, the current and next versions and which files would be updated when the increment ran.



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

To create a version specify the new version store and use -q to set the value of digits.  If a release name is used use --release. 

```cmd
versonify --command=CreateVersion -v="%TEMP%\bugrepro2.store" -Q="<major>.<minor>.<build>.<revision>" --release=<name>
```



#### Set the current version

```cmd
versonify --command=set -v="%TEMP%\bugrepro2.store" -Q="1.2.3.4" 
```

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



#### Create a versonify configuration file  or upgrade the configuration.

You are able to upgrade multiple version stores to use grouping, and you are able to upgrade older configuration to use a new configuration file.

##### Migrating to configuration files



##### Migrating To A Single Vstore File

If there is more than one version store file used then you can migrate to a single file using groups.  Identify the main version number and the secondary ( usually called pre or pre-release).  Identify the pre-release digits and add them to the main versioning store, setting their group.  If they are pre-release ones use the shortcut -p command.  Otherwise create a named group using the filename to indicate the intent.

Often the pre-release version duplicates the main version - and uses a hypen to indicate pre-release digits.  E.g. for a main version `1.2.3.4` the pre-release would likely be `1.2.3.4-Austen.9.8` and in this instance the pre, release digits to add are `austen` with a prefix of `-` and `9` and `8` each with a . prefix. 

To perform a migration follow the following sequence:

1.  Compare the pre-release and release digits.  Execute the command `versonify passive --version-source="<VERSIONSOURCE>"` for the pre and the main version.  For the worked example in the remainder of the steps the return for this for the main version was `2.0.0.0` and for the pre version it was `2.0.0-Bronte.1.4`
2.  Identify the common digits.  This will be the digits before where the pre-release differs.  For our example the common digits would be `2.0.0`.
3.  Identify the combined version number.  Use the values for the common digits from the release version.  Use the remainder of the digits from the pre-release version.  In this example the combined version would be `2.0.0-Bronte.1.4` 
4.  For each digit execute the following command.  `versonify get --digits=<DIGITID> --version-source="<VERSIONSOURCE>" --output=jcon`   Use the version source for the correct digits, so in our example digits 1,2 and 3 would execute against the main version store and 4 5 and 6 against the pre version store.  Each execution will return JSON in the following format:   
      ```  {"1":      {"digitValue":"0","digitBehaviour":"Fixed","digitQueuedOverride":null,"digitPrefix":".","digitgroup":"default"}}```
5.  Using the information create the new version source using the following commands.  First create the new version source using the correct version number.  Make sure that you use a suitably named new version source.  `versonify --command=createversion --version-source=<NEWVSTORENAME> -q="1.0.0.Bronte.1.4"`
6.  Using the information from the Json retrieved earlier update the behaviour and prefix for each digit. First set any prefixes that are not `.` using the command `versonify --command=prefix -d=<DIGITPOSITION> --version-source="<VERSIONSOURCE>" -q="<PREFIX>"`  Note that digits are 0 referenced so for our worked example we would set digit 3 to a prefix of `-`.  For the behaviour use the command `versonify --command=behaviour -d=<DIGITPOSITION> --version-source="<VERSIONSOURCE>" -q="<PREFIX>"` Use the behaviour for each of the digits and set it in the new file.
7.  Assign the correct digit groups.  For the digits that are part of the pre-release run the command to set the pre-release group `versonify --command=set -d=<DIGITPOSITION> --version-source="<VSTORENAME>" --pre-release`.   Do this for each of the pre-release digits, in our example this would be digits 3, 4 and 5.
8.  Execute the passive command to check that the version displays correctly.  First run it without the `--pre-release` switch and then with that switch.  In our example this should return `2.0.0` and `2.0.0-Bronte.1.4`



##### Updating a nuke or fallout build.

Once the file is migrated you need to check whether this is a nuke or fallout build.  Look for a csproj which is called build or references the nuke or fallout nuget packages.  If you find one follow these steps.

1 Identify where the versioning change takes place.  The verisoning step will be in the code and will have a series of calls to versonify using the tooling.  An example would look something like the following code:

```
public Target ApplyVersion => _ => _
  .After(ConstructStep)
  .DependsOn(Initialise)
  .Before(Compile)
  .Executes(() => {
  
     string vtFile = settings.VersioningPersistanceToken;
     if (!PreRelease) {
        vtFile = settings.VersioningPersistanceTokenRelease;
        versioningType = "Release";
      }

     var vc = new VersonifyTasks();
     vc.PassiveCommand(s => s
       .SetVersionPersistanceValue(vtFile)
       .SetOutputStyle("console-nf")
       .SetRoot(Solution.Directory)
     );

     var mmPathBase = settings.DependenciesDirectory / "automation";
     var mmPath = mmPathBase / "autoversion.txt";

     if (IsMajor) {
         vc.OverrideCommand(s => s
           .SetVersionPersistanceValue(vtFile)
           .SetOutputStyle("console-nf")
           .AsDryRun(dryRunMode)
           .SetRoot(Solution.Directory)
           .SetQuickValue(MAJOR_QUICK_VALUE)
        );
 } else if (IsMinor) {
     vc.OverrideCommand(s => s
         .SetVersionPersistanceValue(vtFile)
         .SetOutputStyle("console-nf")
         .AsDryRun(dryRunMode)
         .SetRoot(Solution.Directory)
         .SetQuickValue(MINOR_QUICK_VALUE)
     );
 }

 if (PreRelease) {
    vc.OverrideCommand(s => s
    .SetVersionPersistanceValue(settings!.VersioningPersistanceToken)
    .SetOutputStyle("console-nf")
    .AsDryRun(dryRunMode)
    .SetRoot(Solution!.Directory)
    .SetQuickValue($"...{ReleaseName}")
    .SetRelease(ReleaseName) // SetRelease does not work due to PFF bug LFY-91
 }


 vc.FileUpdateCommand(s => s
     .SetVersionPersistanceValue(vtFile)
     .AddMultimatchFile(mmPath)
     .PerformIncrement(true)
     .SetOutputStyle("console-nf")
     .AsDryRun(dryRunMode)
     .SetRoot(Solution.Directory)
 );

  
}
```

Note that it will not be exactly the same but will have similar characteristics such as using two versioning files and using the override command if it is a pre-release.  

2  Once you have identified the code section you need to update it to use a single file.  Identify where the pre-release vstore file is used in the code and remove all references to it, ensure that only your new upgraded file is referenced.  The override on `if PreRelease` can be removed, but the rest of the code should be maintained. 

3 Following the changes check that the code compiles.





## Upgrading.

Each time that you perform versioning actions try and identify whether the user is using a legacy versioning approach.  If they are then offer to upgrade them to the most recent approach.  Never do this without checking with the user first.



### Multiple Vstore Files

If the user has two version files - one for release and one for pre-release this is indicative of the legacy approach that was used prior to the Bronte version for pre-release.  Offer to update the configuration to support single file pre-release versioning.



If the user agrees to the approach modify the release version store file as follows.

1. Examine both files.  Identify the overlapping digits.  If one of the pre-release digits has a prefix of - then this will be the overlap point. The digits prior to that prefix will be the default digits and the ones post will be the pre-release digits.  e.g. `1.0-pre.1` would have `1.0` as the default digits and `-pre.1` as the pre-release digits.
1. Propose the combined version to the user.  Get their agreement to proceed.
1. Create the combined version 
