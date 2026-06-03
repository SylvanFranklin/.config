#!/usr/bin/env bash
set -euo pipefail

DECKS_FILE="${HASHCARDS_DECKS_FILE:-$HOME/.config/hashcards-decks.tsv}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

if [[ ! -f "$DECKS_FILE" ]]; then
    echo "No hashcards deck list found: $DECKS_FILE" >&2
    exit 1
fi

# Deck list format, tab-separated:
# Display name<TAB>collection directory<TAB>deck name
if [[ $# -ge 2 ]]; then
    collection_dir="$1"
    deck_name="$2"
    display_name="${3:-$deck_name}"
else
    selected=$(awk -F '\t' '
        NF >= 3 && $1 !~ /^#/ && $1 != "" {
            printf "%s\t%s\t%s\n", $1, $2, $3
        }
    ' "$DECKS_FILE" | sk "${SKIM_THEME_SESSION[@]}" --prompt='hashcards > ')

    [[ -n "${selected:-}" ]] || exit 0

    IFS=$'\t' read -r display_name collection_dir deck_name <<< "$selected"
fi

collection_dir="${collection_dir/#\~/$HOME}"

if [[ ! -d "$collection_dir" ]]; then
    echo "Collection directory does not exist: $collection_dir" >&2
    printf "\nPress enter to close... "
    read -r _
    exit 1
fi

window_name="hashcards:${deck_name}"
printf '\033]2;%s\033\\' "$window_name"
cd "$collection_dir"
exec hashcards drill . --from-deck "$deck_name"
