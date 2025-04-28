# Initialize and configure Zsh
autoload -Uz compinit
compinit

# Save history between sessions
HISTFILE=~/.zsh_history       # Location of history file
HISTSIZE=1000                 # Number of commands to keep in memory
SAVEHIST=1000                 # Number of commands to save to history file
AUTOCOMPLETE='/usr/share/zsh/site-functions/'

# Share history across multiple sessions
setopt appendhistory          # Append new history to the file instead of overwriting
setopt incappendhistory       # Immediately append new commands to the history file
setopt sharehistory           # Share history across all sessions
setopt histfindnodups         # Avoid showing duplicates when searching history
setopt HIST_EXPIRE_DUPS_FIRST 

# Better tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Environment variables
export GOPATH=/opt/go_modules/
export AZCOPY_AUTO_LOGIN_TYPE=AZCLI
export LIBVA_MESSAGING_LEVEL=1
export MICROK8s=$(hostname -I | awk '{print $1}')
export SDKMAN_DIR="/opt/sdkman"
export VIRTUAL_ENV_DISABLE_PROMPT=0

# Conditional Aqua setup
if [ -d "/opt/aquaproj-aqua" ]; then
    export AQUA_ROOT_DIR="/opt/aquaproj-aqua"
else
    sudo mkdir -p /opt/aquaproj-aqua
    sudo chown -R $(whoami) /opt/aquaproj-aqua
    export AQUA_ROOT_DIR="/opt/aquaproj-aqua"
fi
export PATH="${AQUA_ROOT_DIR}/bin:$PATH"

# Load Cargo environment if exists
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# SDKMAN initialization
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Check if in an SSH session
if [[ -n $SSH_CONNECTION ]]; then
    alias ls="ls --color=auto"
    TERM="xterm-256color"
fi

# Add local binaries to PATH
export PATH=$PATH:$HOME/.local/bin

# Set editor
export EDITOR='nvim'

## Oh My Zsh update settings
#izstyle ':omz:update' mode auto
#zstyle ':omz:update' frequency 1

# Disable magic functions
export DISABLE_MAGIC_FUNCTIONS="true"

# Source Zsh configuration files
source_files() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        for file in "$dir"/*.zsh; do
            [[ -f "$file" ]] && source "$file"
        done
    fi
}

source_files /opt/zsh.d/variables
source_files /opt/zsh.d/work

# Aliases
alias distro-sync="sudo dnf clean all && sudo dnf distro-sync"
alias docker-run='docker run --rm -it '$1

# Function to remove comments from files
no_comments() {
    [[ ! -f $1 ]] && echo "File not found!" && return 1

    case $1 in
        *.tf)  sed '/^#/d; /^\/\//d; /\/\*/,/\*\//d' "$1" | grep -v '^\s*$' ;; # Terraform
        *.py)  grep -v '^#' "$1" | grep -v '^\s*$' ;; # Python
        *.js | *.ts) grep -v '^//' "$1" | grep -v '^\s*$' ;; # JavaScript/TypeScript
        *)     grep -v '^#' "$1" | grep -v '^\s*$' ;; # Default
    esac
}


# Initialize Starship prompt
#[[ -x "$(command -v starship)" ]] && eval "$(starship init zsh)"
 eval "$(starship init zsh)"

