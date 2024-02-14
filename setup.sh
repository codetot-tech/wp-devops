#!/bin/bash

echo "Copy a script maintenance.sh from other existing folder."

"Remove old file"
git rm -rf scripts/
git commit -m "Remove old scripts"

echo "Create folder scripts if no exists"
mkdir scripts

echo "Copy file"
cp -r ../$1/scripts/maintenance.sh scripts/

echo "CHMOD +x maintenance.sh"
chmod +x scripts/*.sh

echo "Commit file"
git add scripts/
git commit -m "Update bash script maintenance 1.2.0"

exit 0
