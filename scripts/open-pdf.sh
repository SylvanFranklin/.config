selected=$(find | sk --margin 10% --color="bw")

if [[ "$selected" == "STOP" ]]; then
    timew stop
		tmux set -g status-right ""
else
    timew start "$selected"
		tmux set -g status-right "$selected "
fi


