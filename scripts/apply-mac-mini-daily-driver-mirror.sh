#!/usr/bin/env bash
set -euo pipefail

target="${1:-sylvan@Sylvans-mac-mini.local}"
config_root="${HOME}/.config"
mirror_brewfile="${config_root}/Brewfile.mac-mini.daily-driver"

"${config_root}/scripts/generate-daily-driver-mirror-brewfile.sh" "$mirror_brewfile"

rsync -az --exclude '.git/' "${config_root}/" "${target}:/Users/sylvan/.config/"

ssh "$target" '
  if [[ -f "$HOME/.config/zsh/.zshrc.headless" ]]; then
    cp "$HOME/.config/zsh/.zshrc.headless" "$HOME/.config/zsh/.zshrc"
  fi
'

for top_level_file in .gitconfig .zprofile; do
  if [[ -f "${HOME}/${top_level_file}" ]]; then
    rsync -az "${HOME}/${top_level_file}" "${target}:/Users/sylvan/${top_level_file}"
  fi
done

ssh "$target" 'cat > ~/.zshrc <<'"'"'EOF'"'"'
source "$HOME/.config/zsh/.zshrc"
EOF'

ssh "$target" '
  set -euo pipefail
  export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.local/bin:$PATH

  brew bundle --file="$HOME/.config/Brewfile.mac-mini.daily-driver"

  if command -v bob >/dev/null 2>&1; then
    bob install stable || true
    bob use stable || true
  fi

  if ! brew services list | awk '"'"'$1 == "colima" && $2 == "started" { found = 1 } END { exit found ? 0 : 1 }'"'"'; then
    brew services start colima || true
  fi
'
