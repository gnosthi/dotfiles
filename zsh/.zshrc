fpath=(~/.zsh/completion $fpath)
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# ===== Basic ZSH Configuration =====
# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt histignorealldups
setopt histignorespace
setopt incappendhistory
setopt sharehistory

# Useful options
setopt auto_cd          # cd by typing directory name
setopt prompt_subst     # Enable prompt substitution
setopt interactive_comments # Allow comments in interactive shell
setopt extended_glob    # Extended globbing
setopt nomatch          # Show error if pattern has no matches
setopt notify           # Report status of background jobs immediately

# ===== Environment Variables =====
# Add common directories to PATH
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Set default editor
export EDITOR='vim'
if command -v nvim &> /dev/null; then
    export EDITOR='nvim'
    alias vim='nvim'
    alias vi='nvim'
fi

# Configure FZF if installed
if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
    export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' -not -path '*/node_modules/*'"
    # Use fd instead of find if available
    command -v fd &> /dev/null && export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
fi

# ===== Zinit Plugins =====
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Oh-my-zsh plugins
# Load a number of plugins from the OMZSH ecosystem

zinit snippet OMZP::git
zinit snippet OMZP::gpg-agent
zinit snippet OMZP::helm
zinit snippet OMZP::aws
zinit snippet OMZP::kind
zinit snippet OMZP::kubectl
zinit snippet OMZP::kitty
zinit snippet OMZP::ansible
zinit snippet OMZP::golang
zinit snippet OMZP::pyenv
zinit snippet OMZP::aliases
zinit snippet OMZP::1password
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose

# Initialize completion system
autoload -Uz compinit
compinit

# Case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' menu select
zmodload zsh/complist

# Syntax highlighting and autosuggestions (loaded in turbo mode)
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

# z.lua for better directory jumping
zinit ice wait lucid
zinit light skywind3000/z.lua

# FZF integration
zinit ice from"gh-r" as"command"
zinit light junegunn/fzf

# Install fzf-tab for better tab completion with fzf
zinit light Aloxaf/fzf-tab

# Git plugin from Oh-My-Zsh
zinit ice lucid wait"0"
zinit snippet OMZP::git

# Directory and navigation plugins
zinit snippet OMZL::directories.zsh

# Useful snippets from OMZ
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::clipboard.zsh

# ===== Oh My Posh Configuration =====
# Initialize Oh My Posh
if command -v oh-my-posh &> /dev/null; then
    # You can change the theme by modifying the path to the theme file
    eval "$(oh-my-posh init zsh --config ~/.cache/oh-my-posh/themes/dracula.omp.json)"
else
    echo "Oh My Posh is not installed. To install it, run:"
    echo "curl -s https://ohmyposh.dev/install.sh | bash"
    echo "The themes are available at ~/.cache/oh-my-posh/themes/"
fi

# ===== Common Aliases =====
# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# List directory contents
alias ls='lsd --color=auto'
alias ll='ls -lah'
alias l='ls -CF'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# System commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Docker aliases (if installed)
if command -v docker &> /dev/null; then
    alias dk='docker'
    alias dkps='docker ps'
    alias dkimg='docker images'
    alias dkrm='docker rm'
    alias dkrmi='docker rmi'
fi

# Kubernetes aliases (if installed)
if command -v kubectl &> /dev/null; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get svc'
    alias kgd='kubectl get deployments'
fi

# ===== Functions =====
# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract most common archive formats
extract() {
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz)  tar xzf $1 ;;
            *.bz2)     bunzip2 $1 ;;
            *.rar)     unrar e $1 ;;
            *.gz)      gunzip $1 ;;
            *.tar)     tar xf $1 ;;
            *.tbz2)    tar xjf $1 ;;
            *.tgz)     tar xzf $1 ;;
            *.zip)     unzip $1 ;;
            *.Z)       uncompress $1 ;;
            *.7z)      7z x $1 ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find files by pattern
ff() {
    find . -type f -name "*$1*"
}

# ===== Custom Local Configuration =====
# Source local config file if it exists (for machine-specific settings)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ===== Completion Initialization =====
# Finalize compinit
zinit cdreplay -q

# pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Load Python environment management aliases
if [ -f ~/.python_aliases ]; then
    source ~/.python_aliases
fi

# Python environment aliases quick reference:
# mkvenv  - Create and activate a new virtualenv with current directory name
# venvinfo - Show current Python version, path and installed packages
# ae      - Activate virtualenv in current directory
# de      - Deactivate current virtualenv
# pyi     - pyenv install
# pyv     - pyenv versions
# po      - poetry
# poad    - poetry add
# poin    - poetry install

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Golang environment
# Go environment variables cheat sheet.
# GOARCH - Target Arch for the Go Compiler
# GOOS - Target OS
# GOPATH (deprecated) - Path to search for go source code. This has been deprecated in favor of modules.
# GOROOT - Path to the Go installation directory
# GOARM - Architecture variant for ARM targets
# GOMAXPROCS - Sets maximum cpus to use
# CGO_ENABLED - Enables or disables CGO (allowing go to call C functions)
# CGO_FLAGS - Flags passed to C compiler when using CGO
# CGO_LDFLAGS - Flags passed to the linker when using CGO.
# GPGC - Controls garbage collection behavior.
# GODEBUG - Controls go debug logging behavior.

export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="agnosterzak"
# source $ZSH/oh-my-zsh.sh

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
