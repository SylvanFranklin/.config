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
    selected=$(fd . "${DIRS[@]}" --max-depth=2 --extension="djvu" --extension="epub" --extension="pdf" --full-path --base-directory "$HOME" \
        | sed "s|^$HOME/||" \
        | sort -uf \
        | sk "${SKIM_THEME_PDF[@]}")

    [[ $selected ]] && selected="$HOME/$selected"
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
