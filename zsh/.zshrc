autoload -U colors && colors
bindkey -e
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

source <(fzf --zsh)
finder() {
    open .
}

zle -N finder
bindkey '^f' finder

normalize() {
  ffmpeg -i "$1" -af loudnorm=I=-14:TP=-1.0:LRA=11 -c:v copy -c:a aac -b:a 192k output.mp4
}


# Basic auto/tab complete:
autoload -U compinit && compinit
autoload -U colors && colors
zmodload zsh/complist

_comp_options+=(globdots)		# Include hidden files.

export PATH="/Users/sylvanfranklin/.local/share/bob/nvim-bin/:$PATH"
export PATH="/Users/sylvanfranklin/Library/Python/3.9/bin/:$PATH"
export PATH="/Users/sylvanfranklin/.local/bin:$PATH"

alias love="/Applications/love.app/Contents/MacOS/love"
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
alias venv="source .venv/bin/activate"
alias vim=nvim
alias vi="nvim"
alias im="nvim"
alias nm="neomutt"
alias p="poetry"
alias mb="~/Documents/projects/microbrew/target/debug/microbrew" 
alias yt="lux"
alias dl="lux"
alias rip="yt-dlp -x --audio-format=\"mp3\""

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

# edit command line
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
export HISTIGNORE='exit:cd:ls:bg:fg:history:f:fd:vim'

MAILSYNC_MUTE=1

# Load zsh-syntax-highlighting; should be last.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
