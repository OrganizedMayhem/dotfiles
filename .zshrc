export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="arrow"
export GOPATH=/opt/go_modules/
source $HOME/.cargo/env
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of loking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

#zstyle ':omz:update' mode auto #options: disabled, auto, reminder      # update automatically without asking
#zstyle ':omz:update' frequency 1
# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"
PATH=$PATH:$HOME/.local/bin
# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

plugins=(
        gitfast
        ansible
        docker
        battery
        web-search
        azure
        kubectl
        helm
        terraform
        vault
        rust
        nmap
        git
        ripgrep
        fzf
        colorize
        sdk
        golang
)

source $ZSH/oh-my-zsh.sh
export LIBVA_MESSAGING_LEVEL=1
source /opt/zsh.d/work_variables.zsh
source /opt/zsh.d/k9s.zsh
source /opt/zsh.d/jfrog.zsh
source /opt/zsh.d/nerdctl.zsh
source /opt/zsh.d/kubectl.zsh
source /opt/zsh.d/kubernetes.zsh
source /opt/zsh.d/nvidia.zsh
# User configuration
alias distro-sync="sudo dnf5 clean all && sudo dnf5 distro-sync"
# Preferred editor for local and remote sessions
# Define the function
# Define the function
no_comments() {
    # Check for file existence
    if [[ ! -f $1 ]]; then
        echo "File not found!"
        return 1
    fi

    # Determine file type and set appropriate comment handling
    case $1 in
        *.tf)  # Terraform files
            # Removing single-line comments starting with # or //
            # and multi-line comments between /* and */
            # then removing empty lines
            sed '/^#/d; /^\/\//d; /\/\*/,/\*\//d' $1 | grep -v '^\s*$'
            ;;
        *.py)
            grep -v '^#' $1 | grep -v '^\s*$'  # Python files
            ;;
        *.js | *.ts)
            grep -v '^//' $1 | grep -v '^\s*$'  # JavaScript/TypeScript files
            ;;
        *)  # Default case for other file types
            grep -v '^#' $1 | grep -v '^\s*$'  # Generic case assuming # as comment
            ;;
    esac
}

# Usage
# cat_no_comments filename


if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
decode () {
  echo "$1" | base64 -d ; echo
}
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
