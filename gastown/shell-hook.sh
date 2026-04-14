#!/bin/zsh
# Gas Town Shell Integration
# Installed by: gt install --shell
# Location: ~/.config/gastown/shell-hook.sh

_gastown_enabled() {
    [[ -n "$GASTOWN_DISABLED" ]] && return 1
    [[ -n "$GASTOWN_ENABLED" ]] && return 0
    local state_file="$HOME/.local/state/gastown/state.json"
    [[ -f "$state_file" ]] && grep -q '"enabled":\s*true' "$state_file" 2>/dev/null
}

_gastown_ignored() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        [[ -f "$dir/.gastown-ignore" ]] && return 0
        dir="$(dirname "$dir")"
    done
    return 1
}

_gastown_already_asked() {
    local repo_root="$1"
    local asked_file="$HOME/.cache/gastown/asked-repos"
    [[ -f "$asked_file" ]] && grep -qF "$repo_root" "$asked_file" 2>/dev/null
}

_gastown_mark_asked() {
    local repo_root="$1"
    local asked_file="$HOME/.cache/gastown/asked-repos"
    mkdir -p "$(dirname "$asked_file")"
    echo "$repo_root" >> "$asked_file"
}

_gastown_offer_add() {
    local repo_root="$1"

    [[ "${GASTOWN_DISABLE_OFFER_ADD:-}" == "1" ]] && return 0
    _gastown_already_asked "$repo_root" && return 0

    [[ -t 0 ]] || return 0

    local repo_name
    repo_name=$(basename "$repo_root")

    echo ""
    echo -n "Add '$repo_name' to Gas Town? [y/N/never] "
    read -r response </dev/tty

    _gastown_mark_asked "$repo_root"

    case "$response" in
        y|Y|yes)
            echo "Adding to Gas Town..."
            local output
            output=$(gt rig quick-add "$repo_root" --yes 2>&1)
            local exit_code=$?
            echo "$output"

            if [[ $exit_code -eq 0 ]]; then
                local crew_path
                crew_path=$(echo "$output" | grep "^GT_CREW_PATH=" | cut -d= -f2)
                if [[ -n "$crew_path" && -d "$crew_path" ]]; then
                    echo ""
                    echo "Switching to crew workspace..."
                    cd "$crew_path" || true
                    # Re-run hook to set GT_TOWN_ROOT and GT_RIG
                    _gastown_hook
                fi
            fi
            ;;
        never)
            touch "$repo_root/.gastown-ignore"
            echo "Created .gastown-ignore - won't ask again for this repo."
            ;;
        *)
            echo "Skipped. Run 'gt rig quick-add' later to add manually."
            ;;
    esac
}

_gastown_hook() {
    local previous_exit_status=$?

    _gastown_enabled || {
        unset GT_TOWN_ROOT GT_RIG
        return $previous_exit_status
    }

    _gastown_ignored && {
        unset GT_TOWN_ROOT GT_RIG
        return $previous_exit_status
    }

    if ! git rev-parse --git-dir &>/dev/null; then
        unset GT_TOWN_ROOT GT_RIG
        return $previous_exit_status
    fi

    local repo_root
    repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
        unset GT_TOWN_ROOT GT_RIG
        return $previous_exit_status
    }

    local cache_file="$HOME/.cache/gastown/rigs.cache"
    if [[ -f "$cache_file" ]]; then
        local cached
        cached=$(grep "^${repo_root}:" "$cache_file" 2>/dev/null)
        if [[ -n "$cached" ]]; then
            eval "${cached#*:}"
            return $previous_exit_status
        fi
    fi

    if command -v gt &>/dev/null; then
        local detect_output
        detect_output=$(gt rig detect "$repo_root" 2>/dev/null)
        eval "$detect_output"

        if [[ -n "$GT_TOWN_ROOT" ]]; then
            (gt rig detect --cache "$repo_root" &>/dev/null &)
        elif [[ -n "$_GASTOWN_OFFER_ADD" ]]; then
            _gastown_offer_add "$repo_root"
            unset _GASTOWN_OFFER_ADD
        fi
    fi

    return $previous_exit_status
}

_gastown_chpwd_hook() {
    _GASTOWN_OFFER_ADD=1
    _gastown_hook
}

case "${SHELL##*/}" in
    zsh)
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd _gastown_chpwd_hook
        add-zsh-hook precmd _gastown_hook
        ;;
    bash)
        if [[ ";${PROMPT_COMMAND[*]:-};" != *";_gastown_hook;"* ]]; then
            PROMPT_COMMAND="_gastown_chpwd_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
        fi
        ;;
esac

_gastown_hook
