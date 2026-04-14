#!/usr/bin/env bash
set -euo pipefail

# Minimal visual defaults intentionally mirrored from the primary Mac.

defaults write com.apple.dock autohide -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark
defaults write NSGlobalDomain AppleShowScrollBars -string Always

killall Dock >/dev/null 2>&1 || true
killall SystemUIServer >/dev/null 2>&1 || true

cat <<'EOF'
Applied macOS cosmetic defaults:
  - Dock auto-hide enabled
  - Menu bar auto-hide enabled
  - Dark appearance enabled
  - Scroll bars always visible
EOF
