#!/bin/bash

CATEGORIES=(
    "MATH"
    "WORKFLOW"
    "STORMY"
    "VIDEO"
    "PROGRAMMING"
    "DRAWING"
    "WASTED"
    "STOP"
)

selected=$(printf "%s\n" "${CATEGORIES[@]}" | sk --margin 10% --color="bw" --bind 'q:abort')
sk_status=$?

if [[ $sk_status -ne 0 || -z "$selected" ]]; then
    exit 0
fi

if [[ "$selected" == "STOP" ]]; then
    timew stop
    tmux set -g status-right ""
else
    timew start "$selected"
    tmux set -g status-right "$selected "
fi
