#! /bin/bash
cd $(tmux run "echo #{pane_start_path}")
url=$(git remote get-url origin) 

open $url || echo "No remote found"
