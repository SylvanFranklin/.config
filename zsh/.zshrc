autoload -U colors && colors
bindkey -e
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
alias vim=nvim

# Basic auto/tab complete:
autoload -U compinit
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

export PATH="/Users/sylvanfranklin/.local/share/bob/nvim-bin/:$PATH"
# Load zsh-syntax-highlighting; should be last.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
alias love="/Applications/love.app/Contents/MacOS/love"
alias venv="source .venv/bin/activate"
alias vi="nvim"
alias nm="neomutt"
export EDITOR="nvim"
