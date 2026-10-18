#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# === ALIASES ===
# Navigation
alias d="z"
alias pd="cd -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Editors
alias v="vim"
alias n="nvim"

# Tmux
alias ta="tmux attach"
alias td="tmux detach"
alias tns="tmux new -s"

# System helpers
alias psa="ps auxf"
alias psg="ps aux | rg"
alias openports="ss -tulanp"

# System control
alias reboot="loginctl reboot"
alias suspend="loginctl suspend"
alias shutnow="loginctl poweroff"

# File operations
alias rm="rm -iv"
alias cp="cp -iv"
alias mv="mv -iv"
alias cpr="cp -riv"
alias rmd="rm -rfv"
alias mkdir="mkdir -pv"

# Disk usage
alias mountedinfo="df -hT"
alias duf="duf -hide special"
alias folders="du -h --max-depth=1"
alias diskspace="du -S | sort -n -r | nvim -"

# Permissions & security
alias sha1="openssl sha1"
alias own="sudo chown -R $USER"

# Dev & tools
alias ga="git add"
alias gd="git diff"
alias gs="git status"
alias gp="git push -u"
alias myip="curl ifconfig.me"
alias oc="opencode --port 3000"
alias bright="brightnessctl set"
alias grep="grep --color=always"
alias rg="rg --color=always --hidden --no-ignore"
alias nettest="nix shell nixpkgs#speedtest-go --command speedtest-go"
alias antigravity="nix run github:jacopone/antigravity-nix#google-antigravity-cli"

# Utilities
alias ff="fastfetch -c my.jsonc"
alias wget="wget -c --limit-rate=15m"
alias open="xdg-open"
alias vol="wpctl get-volume @DEFAULT_AUDIO_SINK@"

# LS commands
alias la="ls -A"
alias lz="ls -lhAi"
alias lh="ls -d .* 2>/dev/null"
alias tree="tree -a 2>/dev/null || ls -R --color=auto"
alias clear="command clear; unset __was_printed"

# === CUSTOM PROMPT ===
config() {
  declare -ag segments=(identity path git prompt)
  declare -ag dynamics=(identity git)

  declare -g use_colors=true
  declare -g use_glyphs=true
  declare -g use_badges=true

  declare -g color_primary="#785cea"
  declare -g color_secondary="#f5992e"
  declare -g color_neutral="#6B9E6B"
  declare -g color_global

  declare -g glyph_badge_left=""
  declare -g glyph_badge_right=""

  if is_root; then
    color_global=$color_secondary
  else
    color_global=$color_primary
  fi

  if is_console; then use_glyphs=false; fi

  PS1=""
  PS2="→ "
  PROMPT_DIRTRIM=2
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWDIRTYSTATE=1

  if [[ $PROMPT_COMMAND != *__print_blank* ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND%;}"
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__print_blank"
  fi
}

init() {
  for segment in "${segments[@]}"; do
    local renderer="render_$segment"
    if ! declare -F "$renderer" >/dev/null; then continue; fi

    if [[ " ${dynamics[*]} " =~ " $segment " ]]; then
      PS1+="\$($renderer) "
    else
      PS1+="$($renderer) "
    fi
  done
}

### Renderers
render_identity() {
  local cmd_status=$?
  local glyph label

  if is_error "$cmd_status"; then
    if $use_glyphs; then glyph=""; else glyph="!"; fi
    glyph="\001\033[5m\002$glyph\001\033[25m\002"
  elif is_ssh; then
    if $use_glyphs; then glyph="󰌘"; else glyph="*"; fi
  elif is_root; then
    if $use_glyphs; then glyph=""; else glyph="#"; fi
  else
    if $use_glyphs; then glyph=""; else glyph="$"; fi
  fi

  if is_ssh || is_su; then
    label="$USER@$HOSTNAME"
  elif is_git; then
    label=$(get_git_project)
  else
    label="${HOSTNAME%%.*}"
  fi

  if $use_badges; then
    make_badge "$glyph $label"
  else
    make_label "$glyph $label"
  fi
}

render_path() {
  local glyph=""
  local label="\w"
  if $use_glyphs; then
    printf "%s %s" "$(make_label "$glyph")" "$label"
  else
    printf "%s" "$label"
  fi
}

render_git() {
  local glyph=""
  if ! is_git; then return 1; fi

  local branch="" ahead=0 behind=0
  local has_untracked=false has_unstaged=false has_staged=false has_removed=false

  while IFS= read -r line; do
    case "$line" in
      "# branch.head "*)
        branch="${line#\# branch.head }"
        ;;
      "# branch.ab "*)
        local parts=($line)
        ahead="${parts[2]#+}"
        behind="${parts[3]#-}"
        ;;
      "? "*)
        has_untracked=true
        ;;
      [12u]" "*)
        local xy="${line:2:2}"
        local x="${xy:0:1}"
        local y="${xy:1:1}"
        if [[ $x != "." ]]; then has_staged=true; fi
        if [[ $y != "." ]]; then
          has_unstaged=true
          if [[ $y == "D" ]]; then has_removed=true; fi
        fi
        if [[ $x == "D" ]]; then has_removed=true; fi
        ;;
    esac
  done < <(git status --porcelain=v2 -b 2>/dev/null)

  if [[ -z $branch || $branch == "(detached)" ]]; then return 1; fi

  local status_str=""
  if $has_untracked; then status_str+=" ?"; fi
  if $has_unstaged; then status_str+=" !"; fi
  if $has_removed; then status_str+=" -"; fi

  if ((ahead > 0)) && ! $has_unstaged && ! $has_untracked && ! $has_removed && ! $has_staged; then
    status_str+=" ↑"
  fi

  local label="$branch$status_str"
  if ! $use_badges; then label="($label)"; fi
  if $use_glyphs; then label="$glyph $label"; fi

  if $use_badges; then
    printf "%s" "$(make_badge "$label" "$color_neutral")"
  elif $use_colors; then
    printf "%s" "$(make_label "$label" "$color_secondary")"
  else
    printf "%s" "$label"
  fi
}

render_prompt() {
  local glyph
  if $use_glyphs && $use_badges; then glyph="󱞩"; else glyph="→"; fi
  if $use_badges; then glyph=" $glyph"; fi
  if $use_glyphs && $use_badges; then
    glyph="\001\033[1m\002$glyph\001\033[0m\002"
  fi
  printf "\n%s" "$(make_label "$glyph")"
}

### Helpers
hex_to_ansi() {
  local hex="${1#\#}"
  local include_bg="${2:-false}"
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))

  if $include_bg; then
    printf "30;48;2;%s;%s;%s" "$r" "$g" "$b"
  else
    printf "2;%s;%s;%s" "$r" "$g" "$b"
  fi
}

make_label() {
  local content=$1
  local color="${2:-$color_global}"
  if [[ -z $content ]]; then return 1; fi

  if $use_colors; then
    printf "\001\033[38;%sm\002" "$(hex_to_ansi "$color")"
  fi
  printf "%b" "$content"
  if $use_colors; then
    printf "\001\033[0m\002"
  fi
}

make_badge() {
  local content=$1
  local color="${2:-$color_global}"
  local glyph_left glyph_right ansi_sequence

  if [[ -z $content ]]; then return 1; fi

  if $use_glyphs; then
    glyph_left=$glyph_badge_left
    glyph_right=$glyph_badge_right
  else
    content=" $content "
  fi

  if $use_colors; then
    ansi_sequence=$(hex_to_ansi "$color" true)
  else
    ansi_sequence=7
  fi

  printf "%s" "$(make_label "$glyph_left" "$color")"
  printf "\001\033[%sm\002" "$ansi_sequence"
  printf "%b" "$content"
  printf "\001\033[0m\002"
  printf "%s" "$(make_label "$glyph_right" "$color")"
}

### Predicates
is_root() { [[ $EUID -eq 0 ]]; }
is_su() { [[ -n $LOGNAME && $USER != "$LOGNAME" ]]; }
is_ssh() { [[ -n "$SSH_CLIENT" ]]; }
is_console() { [[ -t 1 && $TERM == linux ]]; }
is_error() { [[ $1 -ne 0 && $1 -ne 130 ]]; }
is_git() { [[ -n $(get_git_project) ]]; }

get_git_project() {
  if ! command -v git >/dev/null 2>&1; then return 1; fi
  local git_root
  if git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
    printf "%s" "${git_root##*/}"
  fi
}

### Hooks
__print_blank() {
  [[ -n $__was_printed ]] && echo
  __was_printed=1
}

### Initialize
config && init
