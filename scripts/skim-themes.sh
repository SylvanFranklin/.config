#!/usr/bin/env bash
set -euo pipefail

# Shared flag sets for different skim themes.
SKIM_THEME_PDF=(
    --height=80%
    --min-height=20
    --selector='▌'
    --color='bg+:#1c1c1c,fg+:#f5f5f5,hl:#e5a50a,hl+:#ffd166,border:#6c757d,prompt:#8ecae6,info:#94d2bd,spinner:#e76f51,pointer:#e63946,header:#adb5bd'
)

SKIM_THEME_SESSION=(
    --height=100%
    --layout=reverse-list
    --min-height=20
		--info=default
    --scheme=path
		--cycle
    --delimiter='	'
)

SKIM_THEME_LINKS=(
    --margin=0
    --layout=reverse-list
    --height=100%
    --info=inline
    --delimiter=' '
    --cycle
)

skim_theme_flags() {
    local theme="${1:-}"
    local upper_theme="${theme^^}"
    local var_name="SKIM_THEME_${upper_theme}"
    if ! declare -p "${var_name}" >/dev/null 2>&1; then
        return 1
    fi
    local -n flags="${var_name}"
    printf '%s\n' "${flags[@]}"
}
