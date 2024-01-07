#!/bin/bash

# Copyright (c) 2023 by CODE TOT.
# This script is licensed under the MIT license.
# Version: 1.1.8
# CHANGELOG: https://github.com/codetot-tech/wp-devops/issues/1

echo "✨ A maintenance script was supported by CODE TOT. Post your issue on https://github.com/codetot-tech/wp-devops/issues if you have any bugs while running it."

# Check if WP-CLI is installed
if [[ -x "$(command -v wp)" ]]; then
  echo "✅ WP-CLI is installed. You are good to go."
else
  echo "🐛 WP-CLI is not installed. Ask your hosting provider to install it. Exist"
  exit 0
fi

if git rev-parse --is-inside-work-tree &> /dev/null; then
  echo "✅ Current folder is a Git repository."
else
  echo "🐛 Current folder is not a Git repository. Exist."
  exit 0
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [[ "$current_branch" == "master" || "$current_branch" == "production" ]]; then
  echo "✅ This maintenance script is running with branch $current_branch."
else
  echo "🐛 Can you double-check a current branch name? It was not production/master branch."
  exit 0
fi
  
echo "🚧 Check Git status."

git status

if [[ -n $(git status --porcelain) ]]; then
  echo "⚡️ Backup current database."
  wp db export

  echo "⚡️ Update live plugins"
  wp plugin update --all

  if [[ -n $(git status --porcelain) ]]; then
    git add wp-content/plugins/
    git commit -m "🔨 Update live plugins"
  else 
    echo "🦺 There is no plugin update."
  fi
  
  echo "⚡️ Update live themes"
  wp theme update --all
  
  if [[ -n $(git status --porcelain) ]]; then
    git add wp-content/themes/
    git commit -m "🔨 Update core themes"
  else 
    echo "🦺 There is no theme update."
  fi

  echo "⚡️ Update core WP"
  wp core update

  if [[ -n $(git status --porcelain) ]]; then
    git add wp-admin/ wp-includes/ wp-*.php xmlrpc.php index.php
    git commit -m "🔨 Update core WP"
  else 
    echo "🦺 There is no core update."
  fi

  echo "⚡️ Update translations"
  wp language core update
  wp language theme update --all
  wp language plugin update --all

  if [[ -n $(git status --porcelain) ]]; then
    git add wp-content/languages/
    git commit -m "🔨 Update translations"
  else 
    echo "🦺 There is no translation update."
  fi

  echo "🚩 Finish maintenance task."

  echo "🚧 Check Git status."

  git status

  echo "⚡️ Next: Your turn. Push to production (manual)"
  exit 1

else

  echo "🔥 A repository contains uncommit changes. You should manually take care of it before running a script again."
  exit 0

fi
