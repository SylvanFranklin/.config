#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    dir=$(tmux run "echo #{pane_start_path}")
    selected=$(find $dir ~/downloads ~/documents/notes/EDU -mindepth 1 -maxdepth 1 -type f \( -iname \*.png -o -iname \*.gif -o -iname \*.pdf -o -iname \*.jpg -o -iname \*.jpeg -o -iname \*.tiff \) | \
        sed "s|^$HOME/||" | \
        sk --margin 10% --color=bw
    )

    # Add home path back
    if [[ -n "$selected" ]]; then
        selected="$HOME/$selected"
    fi
fi

if [[ -z "$selected" ]]; then
    exit 1
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

tmux new-window -n  $selected_name -d open $selected
