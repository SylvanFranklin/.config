#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Missing required command: $1" >&2
        exit 1
    fi
}

describe_connection() {
    local context="$1"
    local cluster="$2"

    case "$context" in
        ovh-k3s)
            printf 'OVH K3s via SSH API tunnel'
            ;;
        *)
            printf '%s' "$cluster"
            ;;
    esac
}

ensure_connection() {
    local context="$1"

    case "$context" in
        ovh-k3s)
            local socket="$HOME/.ssh/ovh-k3s-tunnel.sock"

            if ssh -S "$socket" -O check ovh-k3s-tunnel >/dev/null 2>&1; then
                return
            fi

            if command -v nc >/dev/null 2>&1 && nc -z 127.0.0.1 16443 >/dev/null 2>&1; then
                return
            fi

            [[ -S "$socket" ]] && rm -f "$socket"
            ssh -fN -M -S "$socket" ovh-k3s-tunnel
            ;;
    esac
}

add_remote_ssh_row() {
    local label="$1"
    local host="$2"
    local connection="$3"

    if ssh -G "$host" >/dev/null 2>&1; then
        rows+="${label}"$'\t'"remote"$'\t'"${connection}"$'\t'"ssh"$'\t'"${host}"$'\n'
    fi
}

require_command kubectl
require_command k9s
require_command sk

current_context="$(kubectl config current-context 2>/dev/null || true)"
context_rows="$(
    kubectl config view -o jsonpath='{range .contexts[*]}{.name}{"\t"}{.context.cluster}{"\t"}{.context.namespace}{"\n"}{end}'
)"

[[ -n "$context_rows" ]] || exit 0

rows=""
while IFS=$'\t' read -r context cluster namespace; do
    [[ -n "$context" ]] || continue

    marker=" "
    [[ "$context" == "$current_context" ]] && marker="*"

    namespace="${namespace:-all namespaces}"
    connection="$(describe_connection "$context" "$cluster")"

    rows+="${marker}${context}"$'\t'"${namespace}"$'\t'"${connection}"$'\t'"context"$'\t'"${context}"$'\n'
done <<< "$context_rows"

add_remote_ssh_row "Ewan cyr" "cyr" "ssh cyr -> k9s"

selected="$(
    printf '%s' "$rows" \
        | sk "${SKIM_THEME_SESSION[@]}" \
            --delimiter=$'\t' \
            --with-nth 1,2,3 \
            --nth 1,2,3 \
            --prompt="k9s> "
)"

[[ -n "$selected" ]] || exit 0

IFS=$'\t' read -r display_context _namespace _connection mode target <<< "$selected"

window_name="${display_context#\*}"
window_name="${window_name# }"

if [[ -n "${TMUX:-}" ]]; then
    tmux rename-window "k9s:$window_name" >/dev/null 2>&1 || true
fi

case "$mode" in
    context)
        ensure_connection "$target"
        exec k9s --context "$target"
        ;;
    ssh)
        exec ssh -t "$target" k9s
        ;;
    *)
        echo "Unknown k9s picker mode: $mode" >&2
        exit 1
        ;;
esac
