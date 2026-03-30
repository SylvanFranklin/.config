
git clone https://github.com/sylvanfranklin/.config
cd .config
brew bundle

defaults write com.apple.dock autohide -bool true
defaults write com.apple.Dock autohide -bool true
defaults write com.apple.Dock autohide-delay -float 1000
defaults write com.apple.universalaccess reduceMotion -bool true

killall SystemUIServer
killall Dock
