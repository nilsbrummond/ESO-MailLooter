# ESO-MailLooter
Elder Scrolls Online (ESO) Addon for functions to auto loot items and gold from in-game mail.

Building
========
The build environment is developed and test Git Shell running on windows 7.  The 7-Zip 
is used to build the .zip file for release.  The MailLooter.txt file is generated during 
the build process from the manifest.txt file.
The build command is as follows to create a .zip file for release:

```sh
sh ./release.sh [test]
```
The use the optional _test_ flag to include the test injection framework.

Testing
=======
To create a test build use the command:
```sh
sh ./release.sh test
```

A test build has additional / "slash" commands available to run the tests.
