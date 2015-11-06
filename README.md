# ESO-MailLooter
Elder Scrolls Online (ESO) Addon for functions to auto loot items and gold from in-game mail.

The latest version (v0.95) of this addon is available in released form at http://www.esoui.com/downloads/info1149-MailLooter.html and is also available on minion ( http://minion.mmoui.com ).

Building
========
The build environment is developed and test runing in a Git Shell on windows 7.  The 7-Zip 
is used to build the .zip file for release.  The MailLooter.txt file is generated during 
the build process from the manifest.txt file.  You may need to edit the release.sh file to set
your path to 7-Zip.
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
```
/maillooter debug on
/maillooter debug off
/maillooter debug hide
/maillooter debug show
/maillooter test <testname>
/maillooter coretest <testname>
```

/maillooter test <testname>
---------------------------
These tests are played by the core module into the UI.  They are only for UI testing.  This class of test is obsolete and being replaced by the 'coretest'.

/maillooter coretest <testname>
-------------------------------
These tests inject a fake ESO Addon API with a different pre-coded mail Inboxes to run the maillooter against.  These test will test both the core and ui modules.
