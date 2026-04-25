#!/bin/bash

set -euo pipefail

workspace="MUSIC"
music_apps=(
    "com.spotify.client|Spotify"
    "com.apple.Music|Music"
)

find_music_window() {
    local entry bundle_id app_name

    for entry in "${music_apps[@]}"; do
        IFS='|' read -r bundle_id app_name <<<"$entry"

        while IFS=$'\t' read -r window_id current_workspace; do
            [[ -z "$window_id" ]] && continue
            printf '%s\t%s\t%s\t%s\n' "$window_id" "$current_workspace" "$bundle_id" "$app_name"
            return 0
        done < <(
            aerospace list-windows --all \
                --app-bundle-id "$bundle_id" \
                --format '%{window-id}%{tab}%{workspace}' 2>/dev/null || true
        )
    done
}

open_music_app() {
    local entry bundle_id app_name

    for entry in "${music_apps[@]}"; do
        IFS='|' read -r bundle_id app_name <<<"$entry"
        if open -b "$bundle_id" >/dev/null 2>&1; then
            return 0
        fi
    done

    return 1
}

aerospace workspace "$workspace"

match="$(find_music_window || true)"

if [[ -z "$match" ]]; then
    open_music_app || exit 0

    for _ in {1..30}; do
        match="$(find_music_window || true)"
        [[ -n "$match" ]] && break
        sleep 0.15
    done
fi

if [[ -n "$match" ]]; then
    IFS=$'\t' read -r window_id current_workspace bundle_id _ <<<"$match"

    if [[ "$current_workspace" != "$workspace" ]]; then
        aerospace move-node-to-workspace --window-id "$window_id" "$workspace" >/dev/null 2>&1 || true
    fi

    aerospace workspace "$workspace"
    aerospace focus --window-id "$window_id" >/dev/null 2>&1 || true
    open -b "$bundle_id" >/dev/null 2>&1 || true
fi
