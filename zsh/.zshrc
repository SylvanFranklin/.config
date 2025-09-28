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


lazy_load_nvm() {
  unset -f node nvm
  export NVM_DIR=~/.nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

node() {
  lazy_load_nvm
  node $@
}

nvm() {
  lazy_load_nvm
  node $@
}

GG_HOME=~/documents/work
export GG_HOME=${GG_HOME} 
export GG_API=${GG_HOME}/gg-api 
export GG_WEB=${GG_HOME}/esports-web/gg-web 
export GG_EW=${GG_HOME}/esports-web 
export GG_GCP_USERNAME="sylvan" 
export NODE_ENV=development 
alias cd-ew="cd ${GG_EW}" 
alias cd-w="cd ${GG_WEB}" 
alias cd-a="cd ${GG_API}"
alias src="source ~/.config/zsh/.zshrc"
alias phpcs="${GG_API}/lib/vendor/bin/phpcs"
alias phpmd="${GG_API}/lib/vendor/bin/phpmd"
export PATH=${GG_API}/ops/bin:$PATH
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH" 
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH" 



# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sylvanfranklin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sylvanfranklin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sylvanfranklin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sylvanfranklin/google-cloud-sdk/completion.zsh.inc'; fi

# Load zsh-syntax-highlighting; should be last.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


