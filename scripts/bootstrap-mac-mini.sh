#!/usr/bin/env bash
set -euo pipefail

BREWFILE="${HOME}/.config/Brewfile.mac-mini"
CONFIG_ROOT="${HOME}/.config"

if ! command -v brew >/dev/null 2>&1; then
  cat <<'EOF'
Homebrew is not installed yet.

Install prerequisites first:
  xcode-select --install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Then rerun:
  ~/.config/scripts/bootstrap-mac-mini.sh
EOF
  exit 1
fi

mkdir -p \
  "${HOME}/.config/scripts" \
  "${HOME}/.config/zsh" \
  "${HOME}/.config/tmux" \
  "${HOME}/.config/yazi" \
  "${HOME}/.config/kanata" \
  "${HOME}/Documents/projects" \
  "${HOME}/.local/bin"

brew update
brew bundle --file="${BREWFILE}"

if command -v bob >/dev/null 2>&1; then
  bob install stable || true
  bob use stable || true
fi

if [ -f "${CONFIG_ROOT}/zsh/.zshrc.headless" ]; then
  cp "${CONFIG_ROOT}/zsh/.zshrc.headless" "${CONFIG_ROOT}/zsh/.zshrc"
fi

cat > "${HOME}/.zshrc" <<'EOF'
source "$HOME/.config/zsh/.zshrc"
EOF

defaults write com.apple.dock autohide -bool true || true
killall Dock >/dev/null 2>&1 || true

if command -v colima >/dev/null 2>&1; then
  colima start --kubernetes || true
fi

cat <<'EOF'
Bootstrap complete.

Recommended follow-up checks:
  brew bundle check --file ~/.config/Brewfile.mac-mini
  docker version
  colima status
  kubectl get nodes
  helm version
EOF
