#!/usr/bin/env bash

# Open the current repository in the browser
cd $(tmux run "echo #{pane_start_path}")
url=$(git remote get-url origin) 

# Check if the repository is on GitHub
if [[ $url == *github.com* ]]; then
    # SSH format git@github.com:user/repo.git
    if [[ $url == git@* ]]; then
        # Removing 'git@' prefix
        url="${url#git@}"
        # Replacing ':' with '/'
        url="${url/:/\/}" 
        # Prefixing with 'https://'
        url="https://$url"
    fi
    # HTTPS format https://github.com/user/repo.git
    open "$url"
else
    echo "This repository is not hosted on GitHub"
fi
