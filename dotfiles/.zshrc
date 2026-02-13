
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# If you come from bash you might have to change your $PATH.

export HOMEBREW_PREFIX=$(brew --prefix)
export SHELL="$HOMEBREW_PREFIX/bin/zsh"
export PATH="$HOMEBREW_PREFIX/opt/openssl@3/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:~/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

export JAVA_HOME=$(/usr/libexec/java_home)

export DO_NOT_TRACK=1

export DOTNET_ROOT="$HOMEBREW_PREFIX/opt/dotnet/libexec"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

export DOCKER_BUILDKIT=1

export OLLAMA_KEEP_ALIVE=10m

export PATH="$HOMEBREW_PREFIX/opt/node@22/bin:$PATH"

export PATH="$HOMEBREW_PREFIX/opt/python@3.12/libexec/bin:$PATH"

export GOPROXY="direct"

export PATH="$PATH:${GOPATH:-$HOME/go}/bin"

export EDITOR='zed --wait'
export KUBE_EDITOR='zed --wait'
export AIDER_EDITOR='zed --wait'

export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib:$LDFLAGS"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include:$CPPFLAGS"
export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/openssl@3/lib/pkgconfig:$PKG_CONFIG_PATH"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/ruby/lib:$LDFLAGS"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/ruby/include:$CPPFLAGS"
export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/ruby/lib/pkgconfig:$PKG_CONFIG_PATH"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/sqlite/include:$CPPFLAGS"
export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/sqlite/lib/pkgconfig:$PKG_CONFIG_PATH"
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/node@22/lib:$LDFLAGS"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/node@22/include:$CPPFLAGS"

if type brew &>/dev/null; then
  FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
  FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$FPATH
  autoload -Uz compinit && compinit -i
fi

source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

plugins=(macos git aws docker kubectl opentofu terraform)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="$HOMEBREW_PREFIX/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

######################### zsh options ################################
setopt ALWAYS_TO_END           # Push that cursor on completions.
setopt AUTO_NAME_DIRS          # change directories  to variable names
setopt AUTO_PUSHD              # push directories on every cd
setopt NO_BEEP                 # self explanatory

######################### history options ############################
setopt EXTENDED_HISTORY        # store time in history
setopt HIST_EXPIRE_DUPS_FIRST  # unique events are more usefull to me
setopt HIST_VERIFY             # Make those history commands nice
setopt INC_APPEND_HISTORY      # immediatly insert history into history file
HISTSIZE=16000                 # spots for duplicates/uniques
SAVEHIST=15000                 # unique events guarenteed
HISTFILE=~/.history

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias myip="curl ipinfo.io | jq .ip"
alias myip-json="curl ipinfo.io | jq"
alias bzip="gtar -jcvf"
alias gzip="gtar -zcvf"
alias zst="gtar --zstd -cvf"
alias refresh-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
alias flush-dns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
eval "$(kompose completion zsh)"
eval "$(ast-grep completions zsh)"
eval "$(op completion zsh)"


eval "$(mise activate zsh)"

eval "$(starship init zsh)"

source <(fzf --zsh)
