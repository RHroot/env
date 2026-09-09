{
  config,
  pkgs,
  env,
  ...
}:
{
  programs.fish.enable = true;

  users.users.${env.username} = {
    shell = pkgs.fish;
  };

  documentation = {
    enable = true;
    man.enable = true;
  };

  programs.zoxide = {
    enable = true;
    package = pkgs.zoxide;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  environment.systemPackages = with pkgs; [
    fish # User-friendly shell with powerful features and plugins
    lolcat # Colorful text output using rainbow gradients
    ripgrep # Fast recursive text search tool (rg)
  ];

  environment.sessionVariables = {
    PAGER = "nvim -";
    COLORTERM = "truecolor";

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";

    LESSHISTFILE = "$HOME/.cache/less_history";
    PYTHON_HISTORY = "$HOME/.local/share/python/history";
  };

  environment.localBinInPath = true;

  programs.bash = {
    enable = true;
    completion.enable = true;

    shellAliases = {
      # Navigation
      d = "z";
      pd = "cd -";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # Editors
      v = "vim";
      n = "nvim";

      # Tmux
      ta = "tmux attach";
      td = "tmux detach";
      tns = "tmux new -s";

      # System helpers
      psa = "ps auxf";
      psg = "ps aux | rg";
      openports = "netstat -tulanp";

      # System control
      shutnow = "shutdown now";
      reboot = "systemctl reboot";
      restart-dm = "sudo systemctl restart display-manager";

      # File operations
      rm = "rm -iv";
      cp = "cp -iv";
      mv = "mv -iv";
      cpr = "cp -riv";
      rmd = "rm -rfv";
      mkdir = "mkdir -pv";

      # Disk usage
      mountedinfo = "df -hT";
      duf = "duf -hide special";
      folders = "du -h --max-depth=1";
      diskspace = "du -S | sort -n -r | nvim -";

      # Permissions & security
      sha1 = "openssl sha1";
      own = "sudo chown -R $USER";

      # Dev & tools
      ga = "git add";
      gd = "git diff";
      gs = "git status";
      gp = "git push -u";
      myip = "curl ifconfig.me";
      oc = "opencode --port 3000";
      bright = "brightnessctl set";
      grep = "grep --color=always";
      rg = "rg --color=always --hidden --no-ignore";
      nettest = "nix shell nixpkgs#speedtest-go --command speedtest-go";
      antigravity = "nix run github:jacopone/antigravity-nix#google-antigravity-cli";

      # Utilities
      ff = "fastfetch -c my.jsonc";
      wget = "wget -c --limit-rate=15m";

      # System Information
      open = "xdg-open";
      vol = "wpctl get-volume @DEFAULT_AUDIO_SINK@";

      # LS commands
      la = "ls -A";
      lz = "ls -lhAi";
      lh = "ls -d .* 2>/dev/null";
      tree = "tree -a 2>/dev/null || ls -R --color=auto";
    };

    promptInit = ''
      config() {
        # Define prompt segments
        declare -ag segments=(identity timestamp path git prompt)
        declare -ag dynamics=(identity git)

        # Define active features
        declare -g use_colors=true
        declare -g use_glyphs=true
        declare -g use_badges=true

        # Define custom colors
        declare -g color_primary="#f5992e"
        declare -g color_secondary="#785cea"
        declare -g color_neutral="#5f5f87"
        declare -g color_global

        declare -g glyph_badge_left=""
        declare -g glyph_badge_right=""

        # Define main color
        if is_root; then
            color_global=$color_secondary
        else
            color_global=$color_primary
        fi

        # Prevent NF glyphs on console sessions
        if is_console; then use_glyphs=false; fi

        # Define prompt variables
        PS1=""
        PS2="→ "
        PROMPT_DIRTRIM=2
        export GIT_PS1_SHOWUNTRACKEDFILES=1
        export GIT_PS1_SHOWDIRTYSTATE=1

        # Preserve prompt command (i.e. not to break VTE)
        if [[ $PROMPT_COMMAND != *__print_blank* ]]; then
            PROMPT_COMMAND="''${PROMPT_COMMAND%;}"
            PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND; }__print_blank"
        fi
      }

      init() {
        for segment in "''${segments[@]}"; do
            local renderer="render_$segment"

            # Skip segments without renderers
            if ! declare -F "$renderer" > /dev/null; then continue; fi

            if [[ "''${dynamics[*]}" =~ $segment ]]; then
                # Evaluate every time
                PS1+="\$($renderer) "
            else
                # Evaluate only once
                PS1+="$($renderer) "
            fi
        done
      }

      ### Renderers

      render_identity() {
        local cmd_status=$?
        local glyph
        local label

        # Define glyph
        if is_error "$cmd_status"; then
            if $use_glyphs; then glyph=""; else glyph="!"; fi
            # Add blinking effect to error state glyph
            glyph="\001\033[5m\002$glyph\001\033[25m\002"
        elif is_ssh; then
            if $use_glyphs; then glyph="󰌘"; else glyph="*"; fi
        elif is_root; then
            if $use_glyphs; then glyph=""; else glyph="#"; fi
        else
            if $use_glyphs; then glyph=""; else glyph="$"; fi
        fi

        # Define label
        if is_ssh || is_su; then
            label="$USER@$HOSTNAME"
        elif is_git; then
            label=$(get_git_project)
        else
            label="''${HOSTNAME%%.*}"
        fi

        # Rendering logic
        if $use_badges; then
            make_badge "$glyph $label"
        else
            make_label "$glyph $label"
        fi
      }

      render_timestamp() {
        local label="\T"

        # Rendering logic
        if $use_badges; then
            make_label "$label"
        else
            make_label "[$label]" "$color_neutral"
        fi
      }

      render_path() {
        local glyph=""
        local label="\w"

        # Rendering logic
        if $use_glyphs; then
            printf "%s %s" "$(make_label "$glyph")" "$label"
        else
            printf "%s" "$label"
        fi
      }

      render_git() {
        local glyph=""
        
        # Prevent if not a repository
        if ! is_git; then return 1; fi

        local branch="" ahead=0 behind=0
        local has_untracked=false has_unstaged=false has_staged=false has_removed=false

        # Use porcelain v2 to get branch, upstream, and file status in one fast call
        while IFS= read -r line; do
            case "$line" in
                "# branch.head "*)
                    branch="''${line#\# branch.head }"
                    ;;
                "# branch.ab "*)
                    local parts=($line)
                    ahead="''${parts[2]#+}"
                    behind="''${parts[3]#-}"
                    ;;
                "? "*)
                    has_untracked=true
                    ;;
                [12u]" "*)
                    local xy="''${line:2:2}"
                    local x="''${xy:0:1}"
                    local y="''${xy:1:1}"
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

        # Build status string with your custom symbols
        if $has_untracked; then status_str+=" ?"; fi
        if $has_unstaged; then status_str+=" !"; fi
        if $has_removed; then status_str+=" -"; fi

        # Upper arrow if needs pushing AND everything is committed (clean tree)
        if (( ahead > 0 )) && ! $has_unstaged && ! $has_untracked && ! $has_removed && ! $has_staged; then
            status_str+=" ↑"
        fi

        local label="$branch$status_str"

        # Use brackets instead of badges
        if ! $use_badges; then
            label="($label)"
        fi

        # Prepend glyph to label
        if $use_glyphs; then
            label="$glyph $label"
        fi

        # Build format string
        if $use_badges; then
            local format="$(make_badge "$label" "$color_neutral")"
        elif $use_colors; then
            local format="$(make_label "$label" "$color_secondary")"
        else
            local format="$label"
        fi

        printf "%s" "$format"
      }

      render_prompt() {
        local glyph

        # Define glyph
        if $use_glyphs && $use_badges; then glyph="󱞩"; else glyph="→"; fi

        # Prepend space character to match badge
        if $use_badges; then glyph=" $glyph"; fi

        # Use bold glyph
        if $use_glyphs && $use_badges; then
            glyph="\001\033[1m\002$glyph\001\033[0m\002"
        fi

        # Prepend newline character
        printf "\n%s" "$(make_label "$glyph")"
      }


      ### Helpers

      hex_to_ansi() {
        local hex="''${1#\#}"
        local include_bg="''${2:-false}"

        local r=$((16#''${hex:0:2}))
        local g=$((16#''${hex:2:2}))
        local b=$((16#''${hex:4:2}))

        if $include_bg; then
            printf "30;48;2;%s;%s;%s" "$r" "$g" "$b"
        else
            printf "2;%s;%s;%s" "$r" "$g" "$b"
        fi
      }

      make_label() {
        local content=$1
        local color="''${2:-$color_global}"

        # Prevent empty content
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
        local color="''${2:-$color_global}"
        local glyph_left
        local glyph_right
        local ansi_sequence

        # Prevent empty content
        if [[ -z $content ]]; then return 1; fi

        if $use_glyphs; then
            # Use NF rounded corners
            glyph_left=$glyph_badge_left
            glyph_right=$glyph_badge_right
        else
            # Use plain padding
            content=" $content "
        fi

        if $use_colors; then
            ansi_sequence=$(hex_to_ansi "$color" true)
        else
            # Reverse video
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

      # Get top-level repository name
      get_git_project() {
        # Skip execution if `git` is not available
        if ! command -v git > /dev/null 2>&1; then return 1; fi

        local git_root
        if git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
            # Return the directory basename
            printf "%s" "''${git_root##*/}"
        fi
      }


      ### Hooks

      # Prepend blank line except after startup or clear
      __print_blank() { [[ -n $__was_printed ]] && echo; __was_printed=1; }

      # The clear command should also reset the flag
      alias clear="command clear; unset __was_printed"


      ### Initialize

      config && init
    '';
  };
}
