
# This is a BASH script.  I have tested running on Windows 7 in a git-shell
# as supplied by the GitHub windows install.  It is not guaranteed to run
# anywhere else.

# You may have to change this here for your own install:
zip_7z="C:/Program Files/7-Zip/7z"


# Build the zip file for release including only the needed files.

if [ -d ./MailLooter ]; then
  echo "Run this script in the MailLooter top level directory."
  exit 1
fi

echo "MailLooter release building"

IFS=' '
ver_str=$(grep "## Version:" MailLooter.txt)
ver_array=(${ver_str// / })
version=${ver_array[2]}
echo "Building release version" ${version}

build_name="MailLooter-${version}.zip"

echo $build_name

cd ..
rm $build_name

cmd="$zip_7z"
echo $cmd
"$cmd" a -tzip $build_name "MailLooter\\" "-xr!.git" "-xr!TODO.txt" "-xr!*.sh"

if [ $? -eq 0 ];  then
  echo ""
  echo "Release build: Success"
  echo ""
else
  echo ""
  echo "Release build: ERROR - FAILED!!!"
  echo ""
fi


