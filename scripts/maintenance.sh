#!/bin/bash

echo "✨ Are you ready to update your "
echo "✨ A maintenance script was supported by CODE TOT. Post your issue on https://github.com/codetot-tech/wp-devops/issues if you have any bugs while running it."

# Check if WP-CLI is installed
if [[ -x "$(command -v wp)" ]]; then
  echo "✅ WP-CLI is installed. You are good to go."

  if git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "✅ Current folder is a Git repository."
    echo "🚧 Check Git status."

    git status
    
    if [ -z "$(git status --untracked-files=no --porcelain)" ]; then 
    
      echo "⚡️ Backup current database."
      wp db export
    
      echo "⚡️ Update live plugins"
      wp plugin update --all
    
      if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
        git add wp-content/plugins/
        git commit -m "🔨 Update live plugins"
      else 
        echo "🦺 There is no theme update."
      fi
      
      echo "⚡️ Update live themes"
      wp theme update --all
      
      if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
        git add wp-content/themes/
        git commit -m "🔨 Update core themes"
      else 
        echo "🦺 There is no theme update."
      fi
    
      echo "⚡️ Update core WP"
      wp core update
    
      if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
        git add wp-admin/ wp-includes/ wp-*.php xmlrpc.php index.php
        git commit -m "🔨 Update core WP"
      else 
        echo "🦺 There is no core update."
      fi
    
      echo "⚡️ Update translations"
      wp language core update
      wp language theme update --all
      wp language plugin updatae --all
    
      if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
        git commit -m "🔨 Update translations"
      else 
        echo "🦺 There is no translation update."
      fi
    
      echo "🚩 Finish maintenance task."

      echo "🚧 Check Git status."

      git status
    
      echo "⚡️ Next: Your turn. Push to production (manual)"
    
    else
    
      echo "🔥 A repository contains uncommit changes. You should manual take care of it before running a script again."
    
    fi

  else

    echo "🐛 Current folder is not a Git repository. Exist."

  fi

else

  echo "🐛 WP-CLI is not installed. Ask your hosting provider to install it. Exist"

fi
