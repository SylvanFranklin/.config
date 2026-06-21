#!/usr/bin/env bash
set -euo pipefail

target_dir="${1:-${PWD}}"
target_dir="${target_dir/#\~/$HOME}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

if [[ ! -d "$target_dir" ]]; then
    echo "Directory does not exist: $target_dir" >&2
    exit 1
fi

cd "$target_dir"
target_dir="$(pwd -P)"

find_tinymist() {
    local candidate

    if command -v tinymist >/dev/null 2>&1; then
        command -v tinymist
        return 0
    fi

    for candidate in \
        "$HOME/.local/share/nvim/mason/packages/tinymist/tinymist-darwin-arm64" \
        "$HOME/.local/share/nvim/typst-preview/tinymist-darwin-arm64" \
        "$HOME/.local/share/opencode/bin/tinymist"
    do
        if [[ -x "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    return 1
}

find_typst_files() {
    if command -v fd >/dev/null 2>&1; then
        fd . . --type=file --extension=typ | sed 's|^\./||'
    else
        find . -type f -name '*.typ' -not -path '*/.git/*' -print | sed 's|^\./||'
    fi
}

list_typst_files() {
    find_typst_files | sort -uf
}

if [[ "${TYPST_PREVIEW_LIST_ONLY:-}" == "1" ]]; then
    list_typst_files
    exit 0
fi

selected="$(
    list_typst_files \
        | sk "${SKIM_THEME_SESSION[@]}" \
            --prompt="typst> " \
        || true
)"

[[ -n "$selected" ]] || exit 0

tinymist_bin="$(find_tinymist || true)"
if [[ -z "$tinymist_bin" ]]; then
    echo "No tinymist executable found" >&2
    printf '\nInstall tinymist or make it available on PATH, then try again.\n'
    printf 'Press enter to close... '
    read -r _
    exit 127
fi

root="${TYPST_PREVIEW_ROOT:-${TYPST_ROOT:-$target_dir}}"

printf '\033]2;%s\033\\' "typst:${selected}"
printf 'Previewing %s\n' "$selected"
printf 'Root: %s\n\n' "$root"

cmd=(
    "$tinymist_bin"
    preview
    --open
    --partial-rendering=true
    --root "$root"
    "$selected"
)

if command -v direnv >/dev/null 2>&1 && [[ -f "$target_dir/.envrc" ]]; then
    exec direnv exec "$target_dir" "${cmd[@]}"
fi

exec "${cmd[@]}"
