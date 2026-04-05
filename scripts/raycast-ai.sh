#!/bin/bash

set -euo pipefail

workspace="RAYCASTAI"
bundle_id="com.raycast.macos"
title_regex="${RAYCAST_AI_TITLE_REGEX:-AI Chat}"

# Raycast only documents the generic extensions deeplink format. The default
# below is an inference for the built-in AI Chat command; override it if your
# Raycast install uses a different command slug.
candidate_deeplinks=()

if [[ -n "${RAYCAST_AI_DEEPLINK:-}" ]]; then
    candidate_deeplinks+=("$RAYCAST_AI_DEEPLINK")
fi

candidate_deeplinks+=(
    "raycast://extensions/raycast/raycast-ai/ai-chat"
)

find_ai_window() {
    aerospace list-windows --all \
        --app-bundle-id "$bundle_id" \
        --format '%{window-id}%{tab}%{window-title}%{tab}%{workspace}' 2>/dev/null \
        | while IFS=$'\t' read -r window_id window_title current_workspace; do
            if [[ "$window_title" =~ $title_regex ]]; then
                printf '%s\t%s\t%s\n' "$window_id" "$window_title" "$current_workspace"
                return 0
            fi
        done
}

open_ai_chat() {
    for deeplink in "${candidate_deeplinks[@]}"; do
        [[ -z "$deeplink" ]] && continue
        if open -g "$deeplink" >/dev/null 2>&1; then
            return 0
        fi
    done

    open -a Raycast >/dev/null 2>&1 || true
}

aerospace workspace "$workspace"
open_ai_chat

for _ in {1..30}; do
    match="$(find_ai_window || true)"
    if [[ -n "$match" ]]; then
        IFS=$'\t' read -r window_id _ current_workspace <<<"$match"

        if [[ "$current_workspace" != "$workspace" ]]; then
            aerospace move-node-to-workspace --window-id "$window_id" "$workspace" >/dev/null 2>&1 || true
        fi

        aerospace workspace "$workspace"
        aerospace focus --window-id "$window_id" >/dev/null 2>&1 || true
        exit 0
    fi

    sleep 0.15
done

exit 0
