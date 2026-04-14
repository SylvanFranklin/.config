#!/usr/bin/env bash
set -euo pipefail

target="${1:-sylvan@Sylvans-mac-mini.local}"
config_root="${HOME}/.config"

rsync -az --exclude '.git/' "${config_root}/" "${target}:/Users/sylvan/.config/"

for top_level_file in .gitconfig .zprofile; do
  if [[ -f "${HOME}/${top_level_file}" ]]; then
    rsync -az "${HOME}/${top_level_file}" "${target}:/Users/sylvan/${top_level_file}"
  fi
done

ssh "$target" '
  set -euo pipefail
  export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.local/bin:$PATH

  if [[ -f "$HOME/.config/zsh/.zshrc.headless" ]]; then
    cp "$HOME/.config/zsh/.zshrc.headless" "$HOME/.config/zsh/.zshrc"
  fi

  cat > "$HOME/.zshrc" <<'"'"'EOF'"'"'
source "$HOME/.config/zsh/.zshrc"
EOF

  brew bundle --file="$HOME/.config/Brewfile.mac-mini.minimal"

  if command -v bob >/dev/null 2>&1; then
    bob install stable || true
    bob use stable || true
  fi

  "$HOME/.config/scripts/apply-macos-cosmetic-defaults.sh"
'

"${config_root}/scripts/sync-raycast-local-state.sh" "$target"

cat <<'EOF'
Applied the curated minimal profile to the Mac mini.

Optional next step:
  ~/.config/scripts/sync-helium-extension-profile.sh sylvan@Sylvans-mac-mini.local
EOF
