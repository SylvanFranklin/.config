autoload -U colors && colors
bindkey -e
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
source <(fzf --zsh)

finder() {
    open .
}
zle -N finder
bindkey '^f' finder

# Basic auto/tab complete:
autoload -U compinit && compinit
autoload -U colors && colors
zmodload zsh/complist

_comp_options+=(globdots)		# Include hidden files.

export PATH="/Users/sylvanfranklin/.local/share/bob/nvim-bin/:$PATH"
# Load zsh-syntax-highlighting; should be last.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias love="/Applications/love.app/Contents/MacOS/love"
alias venv="source .venv/bin/activate"
alias vim=nvim
alias vi="nvim"
alias nm="neomutt"
alias p="poetry"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
