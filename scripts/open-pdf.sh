#!/usr/bin/env bash
set -euo pipefail

DIRS=(
    "$HOME/documents/notes"
    "$HOME/documents/textbooks"
    "$HOME/downloads"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --max-depth=2 --extension="djvu" --extension="epub" --extension="pdf" --full-path --base-directory "$HOME" \
        | sed "s|^$HOME/||" \
        | sort -uf \
        | sk "${SKIM_THEME_PDF[@]}")

    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ -n "$selected" ]] || exit 0

if [[ -n "${TMUX:-}" ]]; then
    tmux new-window -d "exec sioyek $(printf '%q' "$selected")"
else
    exec sioyek "$selected"
fi
