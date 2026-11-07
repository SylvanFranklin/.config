# Codex tab colors

Codex lifecycle hooks run `scripts/codex-tmux-status.sh`, which stores a
window-local `@codex_tab_color`. Both active and inactive tmux tabs display it:

- White: default / Codex session started.
- Yellow: a prompt was submitted and Codex is working.
- Green: Codex finished its turn.
- Red: the turn was interrupted.

Green and red persist across tab switches and session exit, until a new prompt
or Codex session updates the window. A trailing Stop event cannot overwrite an
interruption with green. The color belongs to the window; if multiple Codex
instances share a window, their hook events update the same indicator.

## Setup

Link `~/.codex/hooks.json` to `~/.config/tmux/codex-hooks.json` (merge the hooks
instead if that file already exists), then reload `~/.config/tmux/tmux.conf`.
In Codex CLI, open `/hooks` and review/trust the four command hooks. New or
changed hook definitions must be reviewed before Codex will run them.
Restart existing Codex sessions if they have not discovered the new hooks.

The script does nothing outside tmux. It does not rename windows or inspect
transcripts. This is a turn lifecycle indicator, not a process watchdog: a
forced kill cannot emit an Interrupt hook and may leave the previous color.
