#!/usr/bin/env bash
set -euo pipefail

REMOTE_HOST="${REVERSE_PROXY_REMOTE_HOST:-sylvan@Sylvans-mac-mini.local}"
REMOTE_DIR="${REVERSE_PROXY_REMOTE_DIR:-/Users/sylvan/Documents/projects/reverse-proxy}"
CONFIG_ROOT="${HOME}/.config/services/reverse-proxy"

ssh "${REMOTE_HOST}" "/bin/zsh -lc 'mkdir -p ${REMOTE_DIR}'"
rsync -av \
  --delete \
  --exclude '.env' \
  "${CONFIG_ROOT}/" "${REMOTE_HOST}:${REMOTE_DIR}/"

ssh "${REMOTE_HOST}" "/bin/zsh -lc '
  eval \"\$(/opt/homebrew/bin/brew shellenv)\"
  cd ${REMOTE_DIR}
  cp -n .env.example .env
  docker compose up -d --build
'"

cat <<EOF
Reverse proxy deployed to ${REMOTE_HOST}:${REMOTE_DIR}

Current mode:
  Internal Caddy CA on port 443

Next steps for trusted public certificates:
  1. Create Namecheap DNS records for vimothee.online to 100.85.115.15
  2. Enable Namecheap API access if your account qualifies
  3. Put API values in ${REMOTE_DIR}/.env
  4. Replace Caddyfile with Caddyfile.namecheap
  5. Run: cd ${REMOTE_DIR} && docker compose up -d --build
EOF
