#!/bin/bash

layouts=(
    "math"
    "obs"
)

selected=$(printf '%s\n' "${layouts[@]}" | sk --margin 10% --color="bw")

[[ ! $selected ]] && exit 0

case $selected in
    math)
        # Open alacritty and firefox side by side on workspace 1
        aerospace workspace 1
        open -a Alacritty
        open -na Firefox --args --new-window
        sleep 0.5
        aerospace layout tiles horizontal vertical
        ;;
    obs)
        # Open OBS on its media workspace
        /Users/sylvanfranklin/.config/scripts/aerospace-home.sh --repair 7 com.obsproject.obs-studio app:OBS
        ;;
esac
