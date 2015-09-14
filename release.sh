
# This is a BASH script.  I have tested running on Windows 7 in a git-shell
# as supplied by the GitHub windows install.  It is not guaranteed to run
# anywhere else.

# Run this script in the MailLooter directory.  The .zip release file will
# be placed in the parent directory ( ie next to the MailLooter directory.)

# run command:
# sh release.sh

# You may have to change this here for your own install:
zip_7z="C:/Program Files/7-Zip/7z"


# Build the zip file for release including only the needed files.

if [ -d ./MailLooter ]; then
  echo "Run this script in the MailLooter top level directory."
  exit 1
fi

testmode=0

if [ "$1" = 'test' ]; then
  echo "MailLooter TEST release building"
  testmode=1
else
  echo "MailLooter release building"
fi


IFS=' '
ver_str=$(grep "## Version:" manifest.txt)
ver_array=(${ver_str// / })
version=${ver_array[2]}
echo "Building release version" ${version}

build_name="MailLooter-${version}.zip"
echo $build_name


rm -f MailLooter.txt

if [ $testmode -eq 0 ]; then
  grep -iv test manifest.txt > MailLooter.txt
else
  cp manifest.txt MailLooter.txt
fi

cd ..
rm $build_name


# could clean this up I think but it works.  Don't want to deal with spaces
# in path names any more right now...
cmd="$zip_7z"
#echo $cmd

if [ $testmode -eq 0 ]; then

  # Include all files in the MailLoter directory except for:
  # - any .git subdirectories
  # - TODO.txt  - because ESO thinks this is another addon (all .txt are addons)
  # - *.sh      - build scripts such as this file...
  
  "$cmd" a -tzip $build_name "MailLooter\\" "-xr!.git" "-xr!.gitignore" "-xr!TODO.txt" "-xr!*.sh" "-xr!Test*.lua" "-xr!*Test.lua" "-xr!manifest.txt"
else

  "$cmd" a -tzip $build_name "MailLooter\\" "-xr!.git" "-xr!.gitignore" "-xr!TODO.txt" "-xr!*.sh" "-xr!manifest.txt"

fi

## Done.
if [ $? -eq 0 ];  then
  echo ""
  echo "Release build: Success"
  echo ""
else
  echo ""
  echo "Release build: ERROR - FAILED!!!"
  echo ""
fi


