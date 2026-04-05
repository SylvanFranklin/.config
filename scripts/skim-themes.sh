#!/usr/bin/env bash
set -euo pipefail

# Shared flag sets for different skim themes.
SKIM_THEME_PDF=(
    --margin=0
    --layout=reverse
    --height=100%
    --min-height=20
    --prompt='pdf> '
    --header='⮞ Open document'
    --info=inline
    --selector='▌'
    --color='bg+:#1c1c1c,fg+:#f5f5f5,hl:#e5a50a,hl+:#ffd166,border:#6c757d,prompt:#8ecae6,info:#94d2bd,spinner:#e76f51,pointer:#e63946,header:#adb5bd'
)

SKIM_THEME_SESSION=(
    --margin=0
    --layout=reverse-list
    --height=100%
    --prompt='session> '
    --header='↪ Project session'
    --info=inline
    --selector='▶'
    --scheme=path
    --color='bg+:#050505,fg+:#e6e6e6,hl:#7bd389,hl+:#b9f18c,border:#4a4a4a,prompt:#7aa2f7,info:#89b4fa,pointer:#ff6b6b,header:#a6adc8'
    --cycle
)

SKIM_THEME_LINKS=(
    --margin=0
    --layout=reverse-list
    --height=100%
    --prompt='links> '
    --header='↗ Open link • ctrl-e edit • ctrl-y copy'
    --info=inline
    --delimiter='	'
    --color='bg+:#111111,fg+:#f2f2f2,hl:#8bd3dd,hl+:#c3f0f5,border:#4f5d75,prompt:#ffb703,info:#a8dadc,pointer:#e63946,header:#ced4da'
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
