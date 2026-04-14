#!/usr/bin/env bash
set -euo pipefail

target="${1:-sylvan@Sylvans-mac-mini.local}"
local_config_root="${HOME}/.config/raycast"
remote_config_root="/Users/sylvan/.config/raycast"

mkdir -p "${local_config_root}"

rsync -az "${local_config_root}/" "${target}:${remote_config_root}/"

cat <<'EOF'
Synced repo-managed Raycast state under ~/.config/raycast.

Note:
  Raycast app settings, hotkeys, aliases, and most preferences should use Raycast Cloud Sync.
  This sync only mirrors the repo-managed Raycast files/extensions directory.
EOF
