#!/bin/bash

cd ~/documents/projects || exit
read repo_url
git clone "$repo_url"
repo_name=$(basename -s .git "$repo_url")
tmux switch-client -t "$repo_name" && exit

