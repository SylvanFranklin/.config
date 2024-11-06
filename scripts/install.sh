#!/bin/bash

apps=(
"fish",
"fd",
"fzf",
"gh",
"lazygit",
"meson",
"node",
"ripgrep",
"sk",
"tmux",
)

casks=(
"aerospace",
"alacritty",
"figma",
"firefox",
"font-0xproto-nerd-font",
"font-3270-nerd-font",
"font-agave-nerd-font",
"font-fira-code-nerd-font",
"karabiner-elements",
"keepassxc",
"raycast",
"spotify",
"tor-browser",
)

for app in "${apps[@]}"; do
  echo "Installing $app..."
  brew install "$app"
done

for cask in "${casks[@]}"; do
  echo "Installing cask $cask..."
  brew install --cask "$cask"
done

echo "All applications installed!"
