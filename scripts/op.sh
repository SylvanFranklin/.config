#!/usr/bin/env bash


if [[ $# -eq 1 ]]; then
    selected=$1
else
    dir=$(tmux run "echo #{pane_start_path}")
    selected=$(find $dir ~/downloads ~/documents/notes/EDU ~/documents/textbooks -mindepth 1 -maxdepth 1 -name "*.pdf" | \
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

tmux new-window -n  $selected_name -d zathura $selected
tmux select-window -l

# sleep 0.7
# aerospace focus --dfs-index 1 && aerospace move-node-to-workspace P --focus-follows-window && aerospace macos-native-fullscreen
