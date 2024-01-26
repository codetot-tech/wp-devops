#!/bin/bash

# Copyright (c) 2023 by CODE TOT.
# This script is licensed under the MIT license.
# Version: 1.2.0
# CHANGELOG: https://github.com/codetot-tech/wp-devops/issues/1

echo "✨ A maintenance script was supported by CODE TOT. Post your issue on https://github.com/codetot-tech/wp-devops/issues if you have any bugs while running it."

echo "TASK: Check if WP-CLI available"

if [[ $(wp --info) ]]; then
  echo "✅ PASSED: WP-CLI version: $(wp --info | grep version | awk '{print $2}')"
else
  echo "🚨 ERROR: WP-CLI is not available."
  exit 1
fi

echo "TASK: Check if Git Environment available"

if [[ -d .git ]]; then
  echo "✅ PASSED! This repository is under Git-control."
else
  echo "🚨 ERROR: This directory is not a Git repository."
  exit 1
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [[ "$current_branch" == "master" || "$current_branch" == "production" ]]; then
  echo "✅ PASSED: This maintenance script is running with branch $current_branch only."
else
  echo "🚨 ERROR: Can you double-check a current branch name? It was not production/master branch."
  exit 1
fi

echo "⚡️ TASK: Start backup DB 🚚 "

wp db export

echo "⚡️ TASK: Update plugins using WP-CLI"

wp plugin update --all

if [[ $(git status --porcelain) ]]; then
  git add wp-content/plugins/
  git commit -m "📦️ Update live plugins"
  git push
else
  echo "INFO: No updates or no commit."
fi

echo "⚡️ TASK: Update themes using WP-CLI"

wp theme update --all

if [[ $(git status --porcelain) ]]; then
  git add wp-content/themes/
  git commit -m "📦️ Update live themes"
  git push
else
  echo "INFO: No updates or no commit."
fi

echo "⚡️ TASK: Update translations using WP-CLI"

wp language plugin update --all
wp language theme update --all

if [[ $(git status --porcelain) ]]; then
  git add wp-content/languages/
  git commit -m "📦️ Update live translations"
  git push
else
  echo "INFO: No updates or no commit."
fi

exit 0
