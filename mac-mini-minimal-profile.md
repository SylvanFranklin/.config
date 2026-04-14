# Mac Mini Minimal Profile

This profile is the curated daily-driver mirror for the Mac mini. It is intentionally smaller than the full-machine snapshot on the main Mac.

## Goals

- Preserve the core feel of the primary Mac
- Keep the Mac mini usable as a personal desktop/headless hybrid
- Avoid dragging over stale apps, duplicate browsers, and old experiments
- Make the important parts reproducible with scripts

## Included

### Core apps

- `AeroSpace`
- `Ghostty`
- `Helium`
- `Firefox`
- `Raycast`
- `KeePassXC`
- `Codex`
- `Cursor`
- `Obsidian`

### Core CLI/tools

- `git`
- `tmux`
- `fd`
- `fzf`
- `ripgrep`
- `jq`
- `zoxide`
- `yazi`
- `uv`
- `python@3.12`
- `bob`
- `pyenv`
- `zsh-syntax-highlighting`
- `tailscale`

### Config + dotfiles

- `~/.config`
- `~/.gitconfig`
- `~/.zprofile`
- `~/.zshrc` bootstrapped to source the synced config

### Cosmetic defaults

- Hide Dock
- Hide menu bar
- Dark appearance
- Always-visible scroll bars

## Sync Strategy

### Raycast

- Use Raycast Cloud Sync for app settings, aliases, hotkeys, and primary Raycast preferences: https://manual.raycast.com/cloud-sync
- Sync repo-managed local Raycast files with:
  - `~/.config/scripts/sync-raycast-local-state.sh`

### Firefox

- Use Firefox Sync for bookmarks, passwords, tabs, settings, and add-ons:
  - https://support.mozilla.org/en-US/kb/how-do-i-set-sync-my-computer
  - https://support.mozilla.org/kb/sync

### Helium

- No official sync workflow was established here.
- Helium appears to store Chromium-style profile data at:
  - `~/Library/Application Support/net.imput.helium/Default`
- Use the selective profile sync helper only if you want to mirror Helium’s extensions/bookmarks/preferences:
  - `~/.config/scripts/sync-helium-extension-profile.sh`
- That helper intentionally excludes cookies, login databases, history, and session state.

## Apply

Run:

```bash
~/.config/scripts/apply-mac-mini-minimal-profile.sh
```

Optional Helium extension/profile subset sync:

```bash
~/.config/scripts/sync-helium-extension-profile.sh sylvan@Sylvans-mac-mini.local
```
