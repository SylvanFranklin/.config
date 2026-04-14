# Mac Software Audit

Date: 2026-04-08
Host: `Sylvans-MBP`

## Summary

- Installed Homebrew casks: `55`
- Installed top-level Homebrew formulae: `124`
- This machine is not a clean signal for a full-state mirror. It contains a mix of active daily-driver tools, legacy installs, experimental tools, and stale packages from older workflows.
- For the Mac mini, a strict full mirror would copy too much. A curated mirror is the right model.

## Strong Usage Signals

### Running GUI apps right now

- `Helium`
- `T3 Code (Alpha)`
- `Finder`
- `sioyek`
- `Raycast`
- `Tailscale`
- `ghostty`
- `KeePassXC`
- `Figma`
- `Messages`
- `vesktop`

### Login items

- `Vesktop`
- `Raycast`
- `FigmaAgent`
- `AeroSpace`
- `ActivityWatch`

### Default handlers

- Default browser for `http`/`https`: `Helium`
- Default handler for `mailto`: `Helium`
- Default handler for `public.html`: `Helium`

### Apps explicitly encoded in Aerospace workflow

These are the apps your window manager and workspace bindings are actively designed around:

- `Ghostty`
- `Helium`
- `Vesktop`
- `Messages`
- `Figma`
- `OBS`
- `DaVinci Resolve`
- `Finder`
- `KeePassXC`
- `Anki`
- `sioyek`
- `T3 Code`
- `Codex`
- `Obsidian`
- `Raycast`

## Likely Core Daily-Driver Stack

These have the strongest evidence of being current, intentional tools:

- `AeroSpace`
- `Ghostty`
- `Helium`
- `Firefox`
- `Raycast`
- `KeePassXC`
- `vesktop`
- `Messages`
- `Figma`
- `sioyek`
- `Obsidian`
- `Codex`
- `T3 Code`
- `Cursor`
- `Neovim` via `bob`
- Core shell/tooling configs under `~/.config`

## Likely Optional Or Secondary

Installed, but weaker evidence of being essential to the mirror target:

- `discord`
- `dorion`
- `legcord`
- `thunderbird`
- `tor-browser`
- `spotify`
- `netnewswire`
- `ActivityWatch`
- `Anki`
- `OBS`
- `DaVinci Resolve`

## Clear Signs Of Drift

- Multiple Discord-family clients are installed: `discord`, `dorion`, `legcord`, `vesktop`.
  Current evidence points to `vesktop` as the real daily-driver because it is both running and a login item.
- Multiple browser installs existed recently. After cleanup, your explicitly preferred set is `Helium` plus `Firefox`.
- The Dock is not useful as a usage signal here. It still looks close to the default Apple Dock and does not reflect your real workspace-driven workflow.
- The full Homebrew formula set contains a lot of language ecosystems, CLIs, servers, and experiments that are not all appropriate for a smaller personal-server mirror.

## Minimal Mirror Recommendation For The Mac Mini

If the Mac mini should be a smaller personal daily-driver plus server box, the mirror should start with:

### GUI apps

- `AeroSpace`
- `Ghostty`
- `Helium`
- `Firefox`
- `Raycast`
- `KeePassXC`
- `Codex`
- `Cursor`
- `Obsidian`
- `vesktop` only if you actually want chat on that machine
- `sioyek` only if you actually read PDFs on that machine

### Top-level dotfiles

- `~/.gitconfig`
- `~/.zprofile`
- `~/.zshrc`

### Core config directories

- `~/.config/aerospace`
- `~/.config/ghostty`
- `~/.config/nvim`
- `~/.config/tmux`
- `~/.config/zsh`
- `~/.config/yazi`
- `~/.config/ripgrep`
- `~/.config/scripts`

### Core CLI/tooling

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

## Recommendation

Do not use the raw full-machine package list as the default Mac mini mirror.

Instead:

1. Treat this audit as the source of truth for the first curated profile.
2. Keep a `daily-driver-minimal` profile for the Mac mini.
3. Keep the broader generated mirror file only as a recovery/migration reference, not the default install target.
