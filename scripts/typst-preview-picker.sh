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
target_dir="$(pwd -P)"

find_tinymist() {
    local candidate

    if command -v tinymist >/dev/null 2>&1; then
        command -v tinymist
        return 0
    fi

    for candidate in \
        "$HOME/.local/share/nvim/mason/packages/tinymist/tinymist-darwin-arm64" \
        "$HOME/.local/share/nvim/typst-preview/tinymist-darwin-arm64" \
        "$HOME/.local/share/opencode/bin/tinymist"
    do
        if [[ -x "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    return 1
}

find_typst_files() {
    if command -v fd >/dev/null 2>&1; then
        fd . . --type=file --extension=typ | sed 's|^\./||'
    else
        find . -type f -name '*.typ' -not -path '*/.git/*' -print | sed 's|^\./||'
    fi
}

list_typst_files() {
    find_typst_files | sort -uf
}

shell_join() {
    local arg
    for arg in "$@"; do
        printf '%q ' "$arg"
    done
}

free_port() {
    if command -v python3 >/dev/null 2>&1; then
        python3 -c 'import socket; s = socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()'
        return 0
    fi

    printf '%s\n' "$((30000 + RANDOM % 20000))"
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

if [[ "${TYPST_PREVIEW_LIST_ONLY:-}" == "1" ]]; then
    list_typst_files
    exit 0
fi

selected="$(
    list_typst_files \
        | sk "${SKIM_THEME_SESSION[@]}" \
            --prompt="typst> " \
        || true
)"

[[ -n "$selected" ]] || exit 0

tinymist_bin="$(find_tinymist || true)"
if [[ -z "$tinymist_bin" ]]; then
    echo "No tinymist executable found" >&2
    printf '\nInstall tinymist or make it available on PATH, then try again.\n'
    printf 'Press enter to close... '
    read -r _
    exit 127
fi

root="${TYPST_PREVIEW_ROOT:-${TYPST_ROOT:-$target_dir}}"
data_port="$(free_port)"
control_port="$(free_port)"
while [[ "$control_port" == "$data_port" ]]; do
    control_port="$(free_port)"
done
preview_url="http://127.0.0.1:${data_port}"

printf '\033]2;%s\033\\' "typst:${selected}"
printf 'Previewing %s\n' "$selected"
printf 'Root: %s\n\n' "$root"

cmd=(
    "$tinymist_bin"
    preview
    --no-open
    --partial-rendering=true
    --data-plane-host "127.0.0.1:${data_port}"
    --control-plane-host "127.0.0.1:${control_port}"
    --root "$root"
    "$selected"
)

if [[ -n "${TMUX:-}" ]]; then
    runner_session="${TYPST_PREVIEW_SESSION:-typst-previews}"
    window_name="typst:${selected##*/}"

    preview_command="$(shell_join "${cmd[@]}")"
    if command -v direnv >/dev/null 2>&1 && [[ -f "$target_dir/.envrc" ]]; then
        preview_command="direnv exec $(printf '%q' "$target_dir") $preview_command"
    fi

    runner_command="cd $(printf '%q' "$target_dir") && { $preview_command & preview_pid=\$!; sleep 0.8; open $(printf '%q' "$preview_url") >/dev/null 2>&1 || true; wait \"\$preview_pid\"; }"

    run_in_runner_session "$runner_session" "$window_name" "$runner_command"
    tmux display-message "Started Typst preview in tmux session: $runner_session"
    exit 0
fi

if command -v direnv >/dev/null 2>&1 && [[ -f "$target_dir/.envrc" ]]; then
    direnv exec "$target_dir" "${cmd[@]}" &
    preview_pid=$!
    sleep 0.8
    open "$preview_url" >/dev/null 2>&1 || true
    wait "$preview_pid"
    exit $?
fi

"${cmd[@]}" &
preview_pid=$!
sleep 0.8
open "$preview_url" >/dev/null 2>&1 || true
wait "$preview_pid"
