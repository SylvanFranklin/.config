export PATH=/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/sylvanfranklin/.cargo/bin
export PATH=$PATH:bin/

clear
nu --config ~/.config/nushell/config.nu

# bun completions
[ -s "/Users/sylvanfranklin/.bun/_bun" ] && source "/Users/sylvanfranklin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export HELIX_RUNTIME="$HOME/helix/runtime"

[ -f "/Users/sylvanfranklin/.ghcup/env" ] && source "/Users/sylvanfranklin/.ghcup/env" # ghcup-env
export NVM_DIR="$HOME/.nvm"
export PATH=$PATH:/Users/sylvanfranklin/.spicetify


[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completio

