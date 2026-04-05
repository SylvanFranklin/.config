#!/usr/bin/env bash
set -euo pipefail

LINKS_FILE="${LINKS_FILE:-$HOME/.config/links.tsv}"
FILTER="${1:-all}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

if [[ ! -f "$LINKS_FILE" ]]; then
    echo "Missing links file: $LINKS_FILE" >&2
    exit 1
fi

rows=$(tail -n +2 "$LINKS_FILE")

[[ -n "$rows" ]] || exit 0

selection=$(
    printf '%s\n' "$rows" \
        | sk "${SKIM_THEME_LINKS[@]}" \
            --delimiter=$'\t' \
            --with-nth 1,2 \
            --nth 1,2 \
            --expect=ctrl-e,ctrl-y
)

[[ -n "$selection" ]] || exit 0

key=$(printf '%s\n' "$selection" | sed -n '1p')
line=$(printf '%s\n' "$selection" | sed -n '2p')

if [[ -z "$line" ]]; then
    line="$key"
    key=""
fi

IFS=$'\t' read -r title url <<< "$line"

open_url() {
    if command -v open >/dev/null 2>&1; then
        open "$1"
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$1"
    else
        echo "No URL opener found" >&2
        exit 1
    fi
}

copy_url() {
    if command -v pbcopy >/dev/null 2>&1; then
        printf '%s' "$1" | pbcopy
    elif command -v wl-copy >/dev/null 2>&1; then
        printf '%s' "$1" | wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        printf '%s' "$1" | xclip -selection clipboard
    else
        echo "No clipboard command found" >&2
        exit 1
    fi
}

case "$key" in
    ctrl-e)
        exec nvim "$LINKS_FILE"
        ;;
    ctrl-y)
        copy_url "$url"
        tmux display-message "Copied link: ${title:-$url}"
        ;;
    *)
        open_url "$url"
        ;;
esac
