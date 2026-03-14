# Initialize completion system first
autoload -Uz up-line-or-history down-line-or-history
autoload -Uz add-zsh-hook
zmodload zsh/zle

# -----------------------------
# General Zsh configuration
# -----------------------------

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Source aliases and other modular files
[ -f "$ZDOTDIR/prompt" ] && source "$ZDOTDIR/prompt"
[ -f "$ZDOTDIR/alias" ] && source "$ZDOTDIR/alias"
[ -f "$ZDOTDIR/func" ] && source "$ZDOTDIR/func"

# cmp options
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' verbose true
zstyle ':completion:*' list-all true
zstyle ':completion:*:prefix:*' expand yes
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*:match:*' original only
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*:*:cd:*:*' menu yes select
zstyle ':completion:*:*:cd:*' force-list always
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:*:*:*:*' list-colors "=(#b) #([0-9])# ([0-9])# * *=*fg=10"
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

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
HISTSIZE=100000
SAVEHIST=100000
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
bindkey "^[[Z" reverse-menu-complete  # Shift+Tab for reverse completion

export OLLAMA_NO_UPDATE_CHECK=true

# Auto ls on directory change
_ls_on_cd() {
  if command -v eza >/dev/null 2>&1; then
    eza --icons
  else
    ls --color=auto
  fi
}
add-zsh-hook chpwd _ls_on_cd
