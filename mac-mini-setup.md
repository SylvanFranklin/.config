# Mac Mini Bootstrap Notes

This file is the handoff for future agents setting up `Sylvans-mac-mini.local` or any replacement headless macOS box for Sylvan. It is on the same local network as this machine and is primarily administered over SSH. It is distinct from the separate homelab environment associated with Ewan's cluster.

## Source Machine Snapshot

- Source machine: this Mac
- Date captured: 2026-04-07
- macOS: `26.3.1`
- Architecture: `arm64`
- Shell: `/bin/zsh`
- Primary package manager: Homebrew at `/opt/homebrew`
- Current remote target: `sylvan@Sylvans-mac-mini.local`
- Mac mini state at capture time: macOS `15.7.5`, `arm64`, SSH enabled, no Homebrew installed yet

## Current Role

- Network position: same local network as this Mac
- SSH entrypoint: `ssh sylvan@Sylvans-mac-mini.local`
- Management model: headless, managed primarily over SSH from this Mac
- Intended use: personal health data workloads plus photo and movie storage/services
- Distinction: this machine is not the same thing as the separate homelab server, which is Ewan's cluster
- Default assumption for future personal data or personal media work: this Mac mini is the primary remote deployment target unless replaced or the user says otherwise

## Current Status

- Last verified live: 2026-04-08
- SSH host key was rotated and re-verified on 2026-04-08 before reconnecting
- Homebrew is installed at `/opt/homebrew`
- Dotfiles are present under `~/.config`
- Colima is installed and managed via Homebrew
- Docker CLI is installed and the active Docker context is `colima`
- Kubernetes is enabled through Colima using k3s
- Verified node state on 2026-04-08: `colima` was `Ready` as the single control-plane node on `v1.35.0+k3s1`
- `brew services start colima` has been enabled so the Colima VM should auto-start for the `sylvan` user
- Tailscale CLI is installed on both this Mac and the Mac mini
- This Mac is already connected to Tailscale
- The Mac mini has the Tailscale package installed but Tailscale is not fully configured yet; the local service was not running successfully as of 2026-04-08
- Daily-driver mirror tooling now exists in `~/.config/scripts/generate-daily-driver-mirror-brewfile.sh` and `~/.config/scripts/apply-mac-mini-daily-driver-mirror.sh`
- A generated full-state package mirror file now exists at `~/.config/Brewfile.mac-mini.daily-driver`
- Verified on 2026-04-08: `aerospace`, `ghostty`, `helium-browser`, `firefox`, and `dorion` are installed on the Mac mini
- Verified on 2026-04-08: `nvim` is available in login shells via Bob at `~/.local/share/bob/nvim-bin/nvim`
- Verified on 2026-04-08: top-level `~/.gitconfig`, `~/.zprofile`, and the synced `~/.config` tree are present on the Mac mini
- Verified on 2026-04-08: Portainer CE is running on the Mac mini via Docker and is currently reachable at `https://Sylvans-mac-mini.local:9443`
- Reverse proxy infra-as-code now lives in `~/.config/services/reverse-proxy` with a matching deploy helper at `~/.config/scripts/deploy-reverse-proxy-to-mac-mini.sh`
- A live service inventory now lives at `~/.config/mac-mini-services.md`
- The service inventory can be regenerated from this Mac with `bash ~/.config/scripts/mac-mini-services.sh --markdown`
- Verified on 2026-04-08: user-facing services currently include Portainer, Actual Budget, Cal.com, Open Notebook, Headlamp, Jellyfin, and the Caddy-backed service index
- Verified on 2026-04-08: `brew services list` shows `colima` started and `tailscale` still failing with `error 1`
- Recommended hostname strategy for personal services: use `vimothee.online` subdomains pointed at the Mac mini's Tailscale IPv4 `100.85.115.15`, then terminate TLS on the mini with Caddy
- Current blocker for public browser-trusted certs: Namecheap production API access may not be enabled or available on low-spend accounts, so the shipped default proxy config uses Caddy `tls internal` until DNS or API automation is completed
- Important caveat: the full daily-driver Brewfile is broader than the original server bootstrap and may still require iterative cleanup for stale or moved Homebrew package names over time

## Remote Access

- Same-LAN access: `ssh sylvan@Sylvans-mac-mini.local`
- Preferred off-LAN access target: the Mac mini over Tailscale
- Intended off-LAN connection style after enrollment: `ssh sylvan@<mac-mini-tailscale-name>` or `ssh sylvan@<mac-mini-tailscale-ip>`
- Tailscale setup direction: install/enable the macOS VPN configuration, activate the system extension if required by the installed variant, then run `tailscale up --ssh --hostname sylvans-mac-mini`
- Practical note: because this is macOS, initial Tailscale VPN/system-extension approval may require local GUI approval in System Settings

## Daily Driver Mirror

- Generate the current mirror Brewfile from this Mac with: `~/.config/scripts/generate-daily-driver-mirror-brewfile.sh`
- Apply the mirror to the Mac mini with: `~/.config/scripts/apply-mac-mini-daily-driver-mirror.sh`
- The apply script syncs `~/.config`, copies top-level `~/.gitconfig` and `~/.zprofile`, refreshes the remote `~/.zshrc`, installs the generated Brewfile, and activates Neovim through Bob
- The mirror script currently forces the Mac mini to use `~/.config/zsh/.zshrc.headless` as its active Zsh config after sync, because the main repo `zsh/.zshrc` is more machine-specific and noisier in remote/headless sessions
- Important: the broad daily-driver mirror is now treated as a recovery/reference artifact, not the default Mac mini profile

## Minimal Profile

- Preferred profile for the Mac mini: `~/.config/Brewfile.mac-mini.minimal`
- Apply it with: `~/.config/scripts/apply-mac-mini-minimal-profile.sh`
- Supporting documentation lives at: `~/.config/mac-mini-minimal-profile.md`
- This curated profile keeps the Mac mini smaller than the primary Mac while still syncing the important shell/editor/window-manager configuration
- Cosmetic defaults are applied with: `~/.config/scripts/apply-macos-cosmetic-defaults.sh`
- Repo-managed Raycast files sync with: `~/.config/scripts/sync-raycast-local-state.sh`
- Optional Helium extension/profile subset sync is available via: `~/.config/scripts/sync-helium-extension-profile.sh`

## Personal Preferences To Preserve

- Keep the machine minimal.
- Dock should be hidden.
- Overall look should stay dark/minimal.
- Desktop background should be solid black when a GUI session is used.
- Keyboard preference is Colemak-DH.
- Important nuance: this Mac is not using a native macOS Colemak-DH input source right now. `AppleSelectedInputSources` still shows `ABC`; the Colemak-DH behavior is implemented through Kanata in [kanata.kbd](/Users/sylvanfranklin/.config/kanata/kanata.kbd).
- The Mac mini is intended to be headless and managed primarily from this Mac over SSH.

## How To Inventory This Mac

Use Homebrew as the source of truth for installed packages:

```bash
brew leaves | sort
brew list --cask | sort
brew bundle dump --global --force --describe
```

Use these commands to confirm the current shell and macOS settings:

```bash
sw_vers
uname -m
echo "$SHELL"
defaults read com.apple.dock autohide
defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources
```

## Local Homebrew Formula Snapshot

Top-level formulae from `brew leaves | sort` on 2026-04-07:

```text
aerc
aria2
automake
azure-cli
backgroundremover
bear
biome
bob
btop
cabin
clippy
cmake
cocoapods
colima
composer
derailed/k9s/k9s
docker
docker-compose
dominikbraun/timetrace/timetrace
dylibbundler
emacs
fastapi
fd
fzf
fzy
gdb
gemini-cli
gf
gh
ghc
ghcup
git
go
gspell
gstreamer
gtksourceview5
gtop
haskell-stack
helix
helm
hf
himalaya
homebrew-zathura/zathura/zathura-djvu
homebrew-zathura/zathura/zathura-pdf-mupdf
hostess
imagemagick
ios-deploy
irssi
isync
jq
jupyterlab
kakoune
kanata
lazygit
libadwaita
libgee
libimobiledevice
libsignal-protocol-c
libsoup@2
libxml2
lua-language-server
luarocks
lux
manim
mcabber
meson
mole
monero
msmtp
mysql
mysql@8.4
neomutt
nvm
ollama
omerxx/tools/blocksite
opencode
oven-sh/bun/bun
pass
pipx
pnpm
podman
poetry
portaudio
postgresql@14
profanity
pyenv
python-lsp-server
python-matplotlib
python@3.12
r
rainfrog
rust-analyzer
shivammathur/php/php@7.4
sk
sl
sphinx-doc
spotify_player
sqliteodbc
stern
tailscale
telnet
timewarrior
tldr
tmux
transmission-cli
trash-cli
typescript
typos-cli
typst
typstyle
uv
uvicorn
vala
vldmrkl/formulae/airdrop-cli
weechat
wget
xcodegen
xh
yarn
yazi
yt-dlp
zig
zoxide
zsh-syntax-highlighting
```

## Local Homebrew Cask Snapshot

GUI casks from `brew list --cask | sort` on 2026-04-07:

```text
activitywatch
aerospace
alacritty
alt-tab
anki
audacity
balenaetcher
blackhole-2ch
brave-browser
cameracontroller
claude-code
codex
cursor
db-browser-for-sqlite
discord
distroav
docker-desktop
dorion
electrum
emacs-app
equinox
figma
firefox
font-0xproto-nerd-font
font-3270-nerd-font
font-agave-nerd-font
font-fira-code-nerd-font
font-fontawesome
font-iosevka
font-monoid-nerd-font
gcloud-cli
ghostty
git-credential-manager
godot
google-chrome
helium-browser
karabiner-elements
keepassxc
keycastr
legcord
libndi
logitech-options
microsoft-teams
monero-wallet
mullvad-vpn
netnewswire
obs
obsidian
raycast
rode-central
sioyek
spotify
streamlabs
thunderbird
tor-browser
vesktop
wispr-flow
```

## Config Files That Matter

These are the main configs worth preserving for a CLI-first machine:

- Shell: [zsh/.zshrc](/Users/sylvanfranklin/.config/zsh/.zshrc)
- Tmux: [tmux.conf](/Users/sylvanfranklin/.config/tmux/tmux.conf)
- Git: [.gitconfig](/Users/sylvanfranklin/.gitconfig)
- Yazi: [init.lua](/Users/sylvanfranklin/.config/yazi/init.lua) and [keymap.toml](/Users/sylvanfranklin/.config/yazi/keymap.toml)
- Kanata: [kanata.kbd](/Users/sylvanfranklin/.config/kanata/kanata.kbd)
- CLI helper scripts: [scripts](/Users/sylvanfranklin/.config/scripts)

These local configs are not directly appropriate for the headless Mac mini and should stay out of the initial bootstrap:

- GUI window manager config in [aerospace.toml](/Users/sylvanfranklin/.config/aerospace/aerospace.toml)
- GUI terminal config in [ghostty/config](/Users/sylvanfranklin/.config/ghostty/config)
- GitHub auth tokens in `~/.config/gh/hosts.yml`

## Headless Mac Mini Notes

- Primary access method should be SSH from this Mac.
- Keep the package set CLI-first.
- Avoid GUI casks unless there is a specific later need.
- Prefer storing future projects in `~/Documents/projects`.
- If a GUI session is ever attached, apply the minimal visual preferences then, but do not make the setup depend on GUI interaction.
- Colemak-DH on the mini should also be done with Kanata if a physical keyboard is ever used locally.

## Target Mac Mini Package Set

Do not install every package from the source machine on the mini. Start with the smaller CLI/dev/core set in [Brewfile.mac-mini](/Users/sylvanfranklin/.config/Brewfile.mac-mini):

- Shell and navigation: `git`, `gh`, `tmux`, `fzf`, `fd`, `fzy`, `ripgrep`, `jq`, `wget`, `xh`, `zoxide`, `yazi`, `lazygit`, `btop`, `tldr`
- Editors and runtimes: `bob`, `python@3.12`, `uv`, `pipx`, `node`, `pnpm`, `bun`, `go`
- Remote/headless tools: `tailscale`
- Kubernetes/control plane stack: `docker`, `docker-compose`, `colima`, `kubernetes-cli`, `helm`, `stern`, `k9s`
- Optional local-console keyboard tool: `kanata`

## Mac Mini Setup Plan

1. Install Xcode Command Line Tools on the Mac mini.
2. Install Homebrew in `/opt/homebrew`.
3. Copy this repo’s Mac mini bootstrap files to the mini.
4. Run the bootstrap script to install the CLI package set from Homebrew.
5. Make zsh load the headless-safe shell config instead of the full local GUI-oriented config.
6. Copy tmux, yazi, Kanata, and selected helper scripts.
7. Apply safe macOS defaults for a minimal setup:
   `com.apple.dock autohide = true`
   dark appearance
   black wallpaper when a GUI session exists
8. Install or activate Neovim through `bob`.
9. Start Colima with Kubernetes enabled:
   `colima start --kubernetes`
10. For autostart, prefer `brew services start colima`.
11. Validate with `kubectl get nodes`, `helm version`, `docker version`, `tmux -V`, `git --version`, `uv --version`.

## What Was Blocked During This Session

The Mac mini user `sylvan` can SSH in, but `sudo` requires an interactive password. Because of that, the following steps could not be completed remotely in a non-interactive way from this agent session:

- Xcode Command Line Tools installation
- Homebrew installation
- Any root-owned system changes needed by package installation

Everything else should be staged so a future agent can continue immediately after those password-gated steps are done.

## Suggested Manual Commands On The Mac Mini

Run these on the Mac mini once, locally or in an SSH session with a real TTY:

```bash
xcode-select --install
```

Then install Homebrew using the current official script from `https://brew.sh`:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After that:

```bash
mkdir -p ~/.config/scripts ~/.config/zsh ~/.config/tmux ~/.config/yazi ~/.config/kanata ~/Documents/projects
```

Then run the bootstrap script copied from this repo:

```bash
~/.config/scripts/bootstrap-mac-mini.sh
```

## Colima / Kubernetes Notes

Current Colima docs confirm:

- start Kubernetes with `colima start --kubernetes`
- use `brew services start colima` for autostart

For a headless Mac mini, Colima is the simplest way to get a local single-node Kubernetes control plane without turning the machine into a GUI-heavy workstation.

## Verification Checklist

```bash
brew config
brew bundle check --file ~/.config/Brewfile.mac-mini
git --version
tmux -V
fzf --version
uv --version
docker version
colima status
kubectl get nodes
helm version
k9s version
```
