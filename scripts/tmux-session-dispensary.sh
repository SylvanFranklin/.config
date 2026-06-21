#!/bin/bash

DIRS=(
    "$HOME"
    "$HOME/documents/projects"
    "$HOME/documents"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --type=dir --max-depth=1 --full-path --base-directory $HOME \
        | sed "s|^$HOME/||" \
        | sk "${SKIM_THEME_SESSION[@]}" )

    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name"; then
    tmux new-session -ds "$selected_name" -n "zsh" -c "$selected" "zsh"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"
