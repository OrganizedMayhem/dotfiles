export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="arrow"
source $HOME/.cargo/env
export GOPATH=/opt/go_modules/
export __GL_SYNC_TO_VBLANK=0
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

plugins=(
        gitfast
        ansible
        docker
        kubectl
        helm
        terraform
        vault
        rust
        nmap
        ripgrep
        fzf
)

source $ZSH/oh-my-zsh.sh
export LIBVA_MESSAGING_LEVEL=1
source /opt/zsh_auto/work_variables.zsh
source /opt/zsh_auto/k9s.zsh
source /opt/zsh_auto/jfrog.zsh
source /opt/zsh_auto/nerdctl.zsh
source /opt/zsh_auto/environment.zsh
source /opt/zsh_auto/kubectl.zsh
source /opt/zsh_auto/kubernetes.zsh
#source /opt/zsh_auto/glow.sh
# User configuration
export PATH="$PATH:$JAVA_HOME/bin:$HOME/.local/bin:$(aqua root-dir)/bin"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='lvim'
else
  export EDITOR='nvim'
fi
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
