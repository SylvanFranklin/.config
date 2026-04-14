#!/bin/zsh

set -eu

project_root="/Users/sylvanfranklin/Documents/projects/audio-journal"

pid="$(
	ps -axo pid=,command= \
	| awk -v root="$project_root" '$0 ~ root && $0 !~ /awk -v root=/ { pid=$1 } END { print pid }'
)"

if [ -z "${pid:-}" ]; then
	tmux display-message "audio-journal is not running"
	exit 1
fi

listener="$(
	lsof -nP -a -p "$pid" -iTCP -sTCP:LISTEN -Fn 2>/dev/null \
	| sed -n 's/^n//p' \
	| head -n 1
)"

if [ -z "${listener:-}" ]; then
	tmux display-message "audio-journal has no listener"
	exit 1
fi

case "$listener" in
	\[*\]:*)
		url="http://$listener/"
		;;
	\*:*)
		port="${listener#*:}"
		url="http://127.0.0.1:$port/"
		;;
	*:* )
		url="http://$listener/"
		;;
	*)
		tmux display-message "audio-journal listener parse failed: $listener"
		exit 1
		;;
esac

open "$url"
