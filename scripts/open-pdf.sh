#!/bin/bash

DIRS=(
    "$HOME/documents/notes"
    "$HOME/documents/work"
    "$HOME/documents/projects"
    "$HOME/downloads"
    "$HOME/documents/textbooks"
    "$HOME"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --max-depth=2 --extension="djvu" --extension="epub" --extension="pdf" --full-path --base-directory $HOME \
        | sed "s|^$HOME/||" \
        | sort -uf \
        | sk "${SKIM_THEME_PDF[@]}" )

    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

tmux neww -d sioyek $selected
