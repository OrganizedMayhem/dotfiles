# Initialize and configure Zsh
autoload -Uz compinit
compinit
# Better tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Environment variables
export GOPATH=/opt/go_modules/
export AZCOPY_AUTO_LOGIN_TYPE=AZCLI
export LIBVA_MESSAGING_LEVEL=1
export MICROK8s=$(hostname -I | awk '{print $1}')
export SDKMAN_DIR="/opt/sdkman"
export VIRTUAL_ENV_DISABLE_PROMPT=0
if [ -d "/opt/aquaproj-aqua" ]; then
    export AQUA_ROOT_DIR="/opt/aquaproj-aqua"
fi
export PATH="${AQUA_ROOT_DIR}/bin:$PATH"
# Load Cargo environment
source $HOME/.cargo/env

# SDKMAN initialization
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Add local binaries to PATH
export PATH=$PATH:$HOME/.local/bin

# Set editor
export EDITOR='nvim'

# Oh My Zsh update settings
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Disable magic functions
export DISABLE_MAGIC_FUNCTIONS="true"

# Source Zsh configuration files
source_files() {
    for file in "$1"/*.zsh; do
        [[ -e "$file" ]] && source "$file"
    done
}
source_files /opt/zsh.d/variables
source_files /opt/zsh.d/autocomplete
source_files /opt/zsh.d/work

# Aliases
alias distro-sync="sudo dnf5 clean all && sudo dnf5 distro-sync"
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

# Function to decode base64 strings
decode() {
    echo "$1" | base64 -d
    echo
}
wd() {
    . /usr/local/bin/wd
}
# Initialize Starship prompt
eval "$(starship init zsh)"

