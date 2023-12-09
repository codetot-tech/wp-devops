#!/bin/bash

git status

if [ -z "$(git status --untracked-files=no --porcelain)" ]; then 

  echo "Backup current DB"
  wp db export

  echo "Update live plugins"
  wp plugin update --all

  echo "Commit live plugin changes"
  git add wp-content/plugins/
  git commit -m "Update live plugins"

  echo "Update live themes"
  wp theme update --all
  git commit -m "Update core themes"

  echo "Update core WP"
  wp core update
  git add wp-admin/ wp-includes/ wp-*.php xmlrpc.php index.php
  git commit -m "Update core WP"

  echo "Finish maintenance task"
  git status

  echo "Next: Push to production (manual)"

else

  echo "A repository contains uncommit changes."

fi
