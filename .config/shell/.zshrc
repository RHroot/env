# Initialize completion system first
zmodload zsh/complist
autoload -U compinit && compinit -C
autoload -U colors && colors -C
autoload -Uz up-line-or-history down-line-or-history
autoload -Uz add-zsh-hook

# -----------------------------
# General Zsh configuration
# -----------------------------

if command -v keychain >/dev/null 2>&1; then
  eval "$(keychain --quiet --eval)"
fi
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Function to initialize fzf with shell integration
setup_fzf_integration() {
  if command -v fzf >/dev/null 2>&1; then
    # Find fzf binary and locate its installation directory
    local fzf_bin=$(which fzf)
    local fzf_install_dir=$(dirname $(dirname $fzf_bin))
    
    # Check common locations in order of likelihood
    for dir in "$fzf_install_dir/share/fzf" "$fzf_install_dir/etc/fzf" "$fzf_install_dir/lib/fzf" "$fzf_install_dir/shell"; do
      if [ -f "$dir/key-bindings.zsh" ] && [ -f "$dir/completion.zsh" ]; then
        source "$dir/completion.zsh"
        source "$dir/key-bindings.zsh"
        return 0
      fi
    done
  fi
}
setup_fzf_integration

# Source aliases and other modular files
[ -f "$ZDOTDIR/prompt" ] && source "$ZDOTDIR/prompt"
[ -f "$ZDOTDIR/alias" ] && source "$ZDOTDIR/alias"
[ -f "$ZDOTDIR/func" ] && source "$ZDOTDIR/func"

# LOAD MODULES (already done above)
zmodload zsh/zprof
zmodload zsh/zle

# cmp options
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:*' menu yes select
zstyle ':completion:*:*:cd:*' force-list always
zstyle ':completion:*:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' list-all true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' list-colors "=(#b) #([0-9])# ([0-9])# * *=*fg=10"
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' completer _complete _match _prefix _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:prefix:*' expand yes

# main options
setopt append_history inc_append_history share_history
setopt auto_menu menu_complete
setopt autocd
setopt auto_pushd
setopt cdable_vars
setopt auto_name_dirs
setopt auto_param_slash
setopt pushd_ignore_dups
setopt no_case_glob no_case_match
setopt globdots
setopt extended_glob
setopt interactive_comments
setopt MENU_COMPLETE
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
unsetopt prompt_sp
# stty stop undef

# history options
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh_history"
HISTCONTROL=ignoreboth

bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line
bindkey "^[k" kill-line
bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey "^[p" up-line-or-history
bindkey "^[n" down-line-or-history
bindkey "^b" backward-char
bindkey "^f" forward-char
bindkey -M menuselect "^o" accept-line
bindkey "^[[Z" reverse-menu-complete  # Shift+Tab for reverse completion

export OLLAMA_NO_UPDATE_CHECK=true

# Auto ls on directory change
_ls_on_cd() {
  if command -v eza >/dev/null 2>&1; then
    eza -a --icons
  else
    ls -A --color=auto
  fi
}
add-zsh-hook chpwd _ls_on_cd
