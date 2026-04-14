#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

rows="$(bash "$SCRIPT_DIR/mac-mini-services.sh")"

[[ -n "$rows" ]] || exit 0

selected=$(
    printf '%s\n' "$rows" \
        | sk "${SKIM_THEME_SESSION[@]}" \
            --delimiter=$'\t' \
            --with-nth 1,2,3 \
            --nth 1,2,3 \
            --prompt="services> "
)

[[ -n "$selected" ]] || exit 0

IFS=$'\t' read -r service url source notes <<< "$selected"

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

open_url "$url"
