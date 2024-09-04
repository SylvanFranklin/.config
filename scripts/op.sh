#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/downloads ~/documents ~/documents/notes -mindepth 1 -maxdepth 3 -name "*.pdf" | sk)
fi


selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

tmux new-window -n  $selected_name -d zathura $selected
