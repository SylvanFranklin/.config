#!/usr/bin/env bash
set -euo pipefail

target_dir="${1:-${PWD}}"
target_dir="${target_dir/#\~/$HOME}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

if [[ ! -d "$target_dir" ]]; then
    echo "Directory does not exist: $target_dir" >&2
    exit 1
fi

cd "$target_dir"

classify_script() {
    local path="$1"
    local name first_line

    name="$(basename "$path")"
    first_line=""
    IFS= read -r first_line < "$path" || true

    case "$name" in
        *.py)
            printf 'python'
            return 0
            ;;
        *.sh|*.bash)
            printf 'bash'
            return 0
            ;;
    esac

    case "$first_line" in
        '#!'*python*|'#!'*'/env python'*)
            printf 'python'
            return 0
            ;;
        '#!'*bash*|'#!'*'/env bash'*|'#!'*'/bin/sh'*|'#!'*'/env sh'*|'#!'*zsh*|'#!'*'/env zsh'*)
            printf 'bash'
            return 0
            ;;
    esac

    if [[ -x "$path" ]]; then
        printf 'exec'
        return 0
    fi

    return 1
}

rows="$(
    while IFS= read -r -d '' path; do
        kind="$(classify_script "$path" || true)"
        [[ -n "$kind" ]] || continue
        printf '%s\t%s\t%s\n' "${path#./}" "$kind" "$path"
    done < <(find . -maxdepth 1 -type f -print0 | sort -z)
)"

if [[ -z "$rows" ]]; then
    echo "No bash, Python, or executable scripts found in $target_dir"
    printf "\nPress enter to close... "
    read -r _
    exit 0
fi

selected="$(
    printf '%s\n' "$rows" \
        | sk "${SKIM_THEME_SESSION[@]}" \
            --delimiter=$'\t' \
            --with-nth 1,2 \
            --nth 1,2 \
            --prompt="scripts> "
)"

[[ -n "$selected" ]] || exit 0

IFS=$'\t' read -r display_name kind path <<< "$selected"

printf '\033]2;%s\033\\' "script:${display_name}"
printf 'Running %s from %s\n\n' "$display_name" "$target_dir"

status=0
case "$kind" in
    python)
        if command -v python3 >/dev/null 2>&1; then
            python3 "$path" || status=$?
        elif command -v python >/dev/null 2>&1; then
            python "$path" || status=$?
        else
            echo "No python3 or python executable found" >&2
            status=127
        fi
        ;;
    bash)
        bash "$path" || status=$?
        ;;
    exec)
        "$path" || status=$?
        ;;
    *)
        echo "Unknown script type: $kind" >&2
        status=1
        ;;
esac

printf '\n'
if [[ "$status" -eq 0 ]]; then
    printf 'Finished: %s\n' "$display_name"
else
    printf 'Exited with status %s: %s\n' "$status" "$display_name"
fi

printf 'Press enter to close... '
read -r _
exit "$status"
