# ============================================================================
# ~/.zshrc
# ============================================================================

# ----------------------------------------------------------------------------
# Completion system
# ----------------------------------------------------------------------------
# Add any extra completion dirs to fpath BEFORE compinit (site-functions is
# already on the default fpath, so this is only needed for non-default dirs).
[[ -d /usr/share/zsh/site-functions ]] && fpath=(/usr/share/zsh/site-functions $fpath)

autoload -Uz compinit
# Only do the (slow) security check + full rebuild once every 24h; otherwise
# load the cached dump with -C. This is the single biggest shell-startup win.
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n "$_zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
  # Compile the dump in the background so the next start is even faster.
  { zcompile "$_zcompdump" } &!
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# ----------------------------------------------------------------------------
# History
# ----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000          # commands kept in memory
SAVEHIST=50000          # commands written to disk

setopt SHARE_HISTORY          # share + incremental-append across sessions
                              # (implies APPEND_HISTORY & INC_APPEND_HISTORY,
                              #  so those are no longer set separately)
setopt HIST_EXPIRE_DUPS_FIRST # trim duplicates first when HISTSIZE is exceeded
setopt HIST_IGNORE_DUPS       # don't record an immediately repeated command
setopt HIST_IGNORE_ALL_DUPS   # remove older duplicate of any re-run command
setopt HIST_FIND_NO_DUPS      # don't show dupes when searching
setopt HIST_IGNORE_SPACE      # commands prefixed with a space aren't recorded
setopt HIST_REDUCE_BLANKS     # tidy up whitespace before saving
setopt HIST_VERIFY            # expand !! etc. into the line instead of running

# ----------------------------------------------------------------------------
# Shell options (quality-of-life)
# ----------------------------------------------------------------------------
setopt INTERACTIVE_COMMENTS   # allow # comments in interactive shell
setopt EXTENDED_GLOB          # richer globbing (^, #, ~)
setopt AUTO_PUSHD             # cd pushes onto the dir stack
setopt PUSHD_IGNORE_DUPS      # no duplicate dir-stack entries
setopt NO_BEEP

# ----------------------------------------------------------------------------
# Completion styling
# ----------------------------------------------------------------------------
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ----------------------------------------------------------------------------
# Environment variables
# ----------------------------------------------------------------------------
export EDITOR='nvim'
export GOPATH=/opt/go_modules/
export AZCOPY_AUTO_LOGIN_TYPE=AZCLI
export LIBVA_MESSAGING_LEVEL=1
export SDKMAN_DIR="/opt/sdkman"
export VIRTUAL_ENV_DISABLE_PROMPT=1   # =1 is the conventional "disable";
(( $+commands[microk8s] )) && export MICROK8s=$(hostname -I | awk '{print $1}')                                      # Starship renders the venv itself.
# Oh-My-Zsh-only knob; harmless but a no-op if you're not running OMZ.
export DISABLE_MAGIC_FUNCTIONS="true"

# Aqua: set the root dir if it exists. The original auto-created it with `sudo`
# on every shell where it was missing — that triggers a password prompt at
# startup, so it's removed. Create it once, by hand, if you actually use Aqua:
#   sudo mkdir -p /opt/aquaproj-aqua && sudo chown -R "$(whoami)" /opt/aquaproj-aqua
export AQUA_ROOT_DIR="/opt/aquaproj-aqua"

# ----------------------------------------------------------------------------
# PATH (typeset -U keeps it de-duplicated automatically)
# ----------------------------------------------------------------------------
typeset -U path PATH
path=(
  "$AQUA_ROOT_DIR/bin"
  /opt/go_modules/bin
  "$HOME/.local/bin"
  "$HOME/.lmstudio/bin"     # was hard-coded to /home/sevans; now uses $HOME
  $path
)
export PATH

# ----------------------------------------------------------------------------
# Tool initialization
# ----------------------------------------------------------------------------
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# ----------------------------------------------------------------------------
# SSH session tweaks
# ----------------------------------------------------------------------------
if [[ -n $SSH_CONNECTION ]]; then
  export TERM="xterm-256color"
fi
# Colorized ls everywhere (not just over SSH)
alias ls="ls --color=auto"

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------
alias distro-sync="sudo dnf clean all && sudo dnf distro-sync"

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------
# `docker-run` must be a function: an alias can't capture "$@", so the old
# `alias docker-run='docker run --rm -it '$1` never actually passed an image.
#docker-run() {
#  docker run --rm -it "$@"
#}

# Strip comments + blank lines from a file, by type.
no_comments() {
  [[ ! -f $1 ]] && { echo "File not found!"; return 1; }
  case $1 in
    *.tf)         sed '/^\s*#/d; /^\s*\/\//d; /\/\*/,/\*\//d' "$1" | grep -vE '^\s*$' ;; # Terraform
    *.py)         grep -vE '^\s*#'  "$1" | grep -vE '^\s*$' ;;   # Python
    *.js|*.ts)    grep -vE '^\s*//' "$1" | grep -vE '^\s*$' ;;   # JS/TS
    *)            grep -vE '^\s*#'  "$1" | grep -vE '^\s*$' ;;   # Default
  esac
}

# Source every *.zsh file in a directory (drop-in config).
source_files() {
  local dir="$1" file
  [[ -d "$dir" ]] || return
  for file in "$dir"/*.zsh(N); do
    source "$file"
  done
}
source_files /opt/zsh.d/variables
source_files /opt/zsh.d/work

# ----------------------------------------------------------------------------
# Plugins  (sourcing order matters — see notes below)
# ----------------------------------------------------------------------------
# 1) Autosuggestions
for _p in \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  [[ -r "$_p" ]] && { source "$_p"; break; }
done

# 2) Syntax highlighting  — must be sourced near the END, after other widgets.
#    (If you prefer the faster z-shell/F-Sy-H, swap the paths below.)
for _p in \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -r "$_p" ]] && { source "$_p"; break; }
done

# 3) History-substring-search — must come AFTER syntax highlighting.
for _p in \
  /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh; do
  [[ -r "$_p" ]] && {
    source "$_p"
    bindkey '^[[A' history-substring-search-up      # Up arrow
    bindkey '^[[B' history-substring-search-down    # Down arrow
    break
  }
done
unset _p

# ----------------------------------------------------------------------------
# Prompt (Starship)  — keep this last
# ----------------------------------------------------------------------------
[[ -x "$(command -v starship)" ]] && eval "$(starship init zsh)"
