#!/usr/bin/env bash
set -euo pipefail

target="${1:-sylvan@Sylvans-mac-mini.local}"
local_root="${HOME}/Library/Application Support/net.imput.helium/Default"
remote_root="/Users/sylvan/Library/Application Support/net.imput.helium/Default"
printf -v remote_root_rsync '%q' "${remote_root}/"

if pgrep -x "Helium" >/dev/null 2>&1; then
  echo "Close Helium on this Mac before syncing its profile subset." >&2
  exit 1
fi

if ssh "$target" 'pgrep -x "Helium" >/dev/null 2>&1'; then
  echo "Close Helium on the target Mac before syncing its profile subset." >&2
  exit 1
fi

paths=(
  "Preferences"
  "Secure Preferences"
  "Bookmarks"
  "Bookmarks.bak"
  "Extensions"
  "Extension State"
  "Local Extension Settings"
  "Sync Extension Settings"
)

ssh "$target" "mkdir -p \"${remote_root}\""

for rel_path in "${paths[@]}"; do
  if [[ -e "${local_root}/${rel_path}" ]]; then
    rsync -az "${local_root}/${rel_path}" "${target}:${remote_root_rsync}"
  fi
done

cat <<'EOF'
Synced the Helium profile subset used for browser preferences, bookmarks, and extensions.

Intentionally excluded:
  - Cookies
  - Login Data
  - History
  - session databases

That keeps the sync focused on browser setup rather than authenticated session state.
EOF
