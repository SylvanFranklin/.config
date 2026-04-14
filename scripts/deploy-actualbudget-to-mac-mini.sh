#!/usr/bin/env bash
set -euo pipefail

REMOTE_HOST="${ACTUALBUDGET_REMOTE_HOST:-sylvan@Sylvans-mac-mini.local}"
REMOTE_DIR="${ACTUALBUDGET_REMOTE_DIR:-/Users/sylvan/Documents/projects/actualbudget}"
REMOTE_SOURCE_DIR="${ACTUALBUDGET_REMOTE_SOURCE_DIR:-/Users/sylvan/Documents/projects/actual}"
CONFIG_ROOT="${HOME}/.config/services/actualbudget"
LOCAL_SOURCE_DIR="${ACTUALBUDGET_LOCAL_SOURCE_DIR:-${HOME}/Documents/projects/actual}"

ssh "${REMOTE_HOST}" "/bin/zsh -lc 'mkdir -p ${REMOTE_DIR}/data ${REMOTE_SOURCE_DIR}'"
rsync -av \
  --delete \
  --exclude '.env' \
  --exclude 'data/' \
  "${CONFIG_ROOT}/" "${REMOTE_HOST}:${REMOTE_DIR}/"
rsync -av \
  --delete \
  --exclude '.git/' \
  --exclude 'node_modules/' \
  --exclude 'packages/desktop-client/build/' \
  --exclude 'packages/sync-server/build/' \
  --exclude 'packages/desktop-client/locale/' \
  "${LOCAL_SOURCE_DIR}/" "${REMOTE_HOST}:${REMOTE_SOURCE_DIR}/"

ssh "${REMOTE_HOST}" "/bin/zsh -lc '
  eval \"\$(/opt/homebrew/bin/brew shellenv)\"
  cd ${REMOTE_DIR}
  cp -n .env.example .env
  docker compose up -d --build
'"

cat <<EOF
Actual Budget deployed from ${REMOTE_SOURCE_DIR} to ${REMOTE_HOST}:${REMOTE_DIR}

Open:
  http://Sylvans-Mac-mini.local:5006

Manage on the Mac mini:
  cd ${REMOTE_DIR}
  docker compose ps
  docker compose logs -f
  docker compose up -d --build
EOF
