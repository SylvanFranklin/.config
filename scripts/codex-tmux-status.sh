#!/bin/bash
# Called by Codex lifecycle hooks. Keep output quiet: hook stdout can be context.
set -eu

[[ -n "${TMUX:-}" && -n "${TMUX_PANE:-}" ]] || exit 0
command -v tmux >/dev/null 2>&1 || exit 0

case "${1:-}" in
    start) color=white ;;
    running) color=yellow ;;
    done) color=green ;;
    interrupted) color=red ;;
    *) exit 0 ;;
esac

window=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2>/dev/null) || exit 0
[[ -n "$window" ]] || exit 0

# If Stop follows an interruption, preserve red until the next prompt/session.
if [[ "$1" == done ]]; then
    previous=$(tmux show-options -wqv -t "$window" @codex_tab_color 2>/dev/null) || exit 0
    [[ "$previous" != red ]] || exit 0
fi

tmux set-option -wq -t "$window" @codex_tab_color "$color" 2>/dev/null || exit 0
tmux refresh-client -S 2>/dev/null || true
