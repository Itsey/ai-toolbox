---
name: bilgepump
description: A logging library adding log statements to your code.  Used to instrument the code for diagnostics and monitoring.
metadata:
  author: jim
  version: "1.1"
---

Logger Skill



Add Plisky.Diagnostics to every project in the solution.

Add Plisky.Listeners to any launch project in the solution ( e.g. the  project that has program.cs)



Each class that has any functionality in it in the form of methods should have a protected instance of Bilge declared in the class with a constructor that takes a string of the name of the class.  If the class is sealed make it private not protected.



At the start of any method that has logic in it at b.Info.Flow();



