if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    set fish_greeting
end

starship init fish | source

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /Users/sylvanfranklin/.ghcup/bin # ghcup-env
fish_add_path /Users/sylvanfranklin/.modular/bin
