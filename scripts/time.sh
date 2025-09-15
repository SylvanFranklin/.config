#!/bin/bash

CATEGORIES=(
    "MATH"
		"OTHER"
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

tmux set -g status-interval 5

if [[ "$selected" == "STOP" ]]; then
    timew stop
    tmux set -g status-right "#{?client_prefix, _ ,}#(timew | awk "/^ *Total/ {print \$NF}") #[bg=green,fg=black,bold]#(timew | awk "/^ *Tracking/ {print \" \" \$NF \" \"}")#[bg=default]"
else
    timew start "$selected"
    tmux set -g status-right "$selected #(timew | awk '/^ *Total/ {print \$NF}')"
fi
