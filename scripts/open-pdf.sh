#!/usr/bin/env bash
set -euo pipefail

DIRS=(
    "$HOME/documents/textbooks"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

shell_join() {
    local arg
    for arg in "$@"; do
        printf '%q ' "$arg"
    done
}

ensure_runner_session() {
    local session="$1"

    if tmux has-session -t "$session" 2>/dev/null; then
        return 0
    fi

    tmux new-session -d -s "$session" -c "$HOME" -n home "zsh"
}

run_in_runner_session() {
    local session="$1"
    local window_name="$2"
    local command="$3"

    ensure_runner_session "$session"
    tmux new-window -d -t "$session:" -c "$HOME" -n "$window_name" "$command"
}

list_documents() {
    fd . "${DIRS[@]}" \
        --max-depth=2 \
        --extension="djvu" \
        --extension="epub" \
        --extension="pdf" \
        --full-path \
        --base-directory "$HOME" \
        | sort -uf \
        | while IFS= read -r path; do
            [[ -n "$path" ]] || continue
            printf '%s\t%s\n' "$(basename "$path")" "$HOME/$path"
        done
}

focus_sioyek() {
    local bundle_id="info.sioyek.sioyek"
    local workspace="SIOYEK"
    local window_id=""

    command -v aerospace >/dev/null 2>&1 || return 0

    for _ in {1..20}; do
        window_id="$(
            aerospace list-windows --monitor all \
                --app-bundle-id "$bundle_id" \
                --format '%{window-id}' 2>/dev/null \
                | tail -n 1
        )"

        if [[ -n "$window_id" ]]; then
            aerospace workspace "$workspace" >/dev/null 2>&1 || true
            aerospace focus --window-id "$window_id" >/dev/null 2>&1 || true
            return 0
        fi

        sleep 0.15
    done
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected_row="$(
        list_documents \
            | sk "${SKIM_THEME_PDF[@]}" \
                --delimiter=$'\t' \
                --with-nth 1 \
                --nth 1
    )"

    [[ -n "$selected_row" ]] || exit 0
    IFS=$'\t' read -r _display_name selected <<< "$selected_row"
fi

[[ -n "$selected" ]] || exit 0

if [[ -n "${TMUX:-}" ]]; then
    runner_session="${TMUX_RUNNER_SESSION:-background}"
    run_in_runner_session "$runner_session" "pdf" "exec $(shell_join sioyek "$selected")"
    focus_sioyek
    tmux display-message "Opened PDF in tmux session: $runner_session"
    exit 0
fi

sioyek "$selected" &
focus_sioyek
wait "$!"
