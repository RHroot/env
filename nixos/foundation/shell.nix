{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    zsh-system-clipboard # Zsh plugin to sync clipboard with the system
    fzf # Fuzzy finder for interactive command-line filtering
    zoxide # Smarter cd command with directory jump history
    tmux # Terminal multiplexer for managing multiple sessions
    ripgrep # Fast recursive text search tool (rg)
    bat # cat replacement with syntax highlighting
    bind # Command-line tools for DNS queries (dig, nslookup)
    man # Manual page reader
    eza # Modern ls replacement with icons and git info
    lolcat # Colorful text output using rainbow gradients
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
  };

  environment.sessionVariables = {
    EDITOR = "neovide";
    TERM = "kitty";
    TERMINAL = "alacritty";
    BROWSER = "brave";
    COLORTERM = "truecolor";
    PAGER = "less";
    LESS = "-RFXSiM";

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";

    LESSHISTFILE = "$HOME/.cache/less_history";
    PYTHON_HISTORY = "$HOME/.local/share/python/history";
  };

  environment.shellInit = ''
    add_to_path () {
      case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
      esac
    }

    # User bins
    add_to_path "$HOME/.local/bin"
    add_to_path "$HOME/.local/sbin"

    # npm global bin (from the prefix above)
    add_to_path "$HOME/.local/share/npm/bin"

    # pnpm
    export PNPM_HOME="/home/sten/.local/share/pnpm"
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac

    # Optional traditional dirs (mostly empty on NixOS)
    for p in /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin; do
      case ":$PATH:" in
        *":$p:"*) ;;
        *) PATH="$PATH:$p" ;;
      esac
    done
    export PATH
  '';

  programs.bash = {
    enable = true;
    completion.enable = true;

    shellAliases = {
      # ls (safe defaults)
      ls = "ls --color=auto";
      ll = "ls -lah --color=auto";
      la = "ls -A --color=auto";
      l = "ls -CF --color=auto";

      # navigation
      home = "cd ~";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      pd = "cd -";

      # misc
      c = "clear";
      d = "cd";
      h = "history | grep";
      p = "ps aux | grep";
      less = "less -R";

      # editors
      n = "nvim";
      sn = "sudo nvim";
      v = "vim";
      sv = "sudo vim";
      nv = "neovide";
      snd = "sudo neovide";

      # tmux
      tns = "tmux new -s";
      ta = "tmux attach";
      td = "tmux detach";

      # networking / system
      myip = "curl ifconfig.me";
      ping = "ping -c 5";
      openports = "ss -tulpen";
      reboot = "systemctl reboot";
      shutdown = "shutdown now";
      restart-dm = "sudo systemctl restart display-manager";

      # disk / fs
      mkdir = "mkdir -p";
      cp = "cp -iv";
      cpr = "cp -r";
      rmd = "rm -rfv";
      mx = "chmod a+x";

      # safer chmod aliases (explicit)
      chmod644 = "chmod -R 644";
      chmod755 = "chmod -R 755";
      chmod777 = "chmod -R 777";

      # utils
      topcpu = "ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10";
      diskspace = "du -S | sort -n -r | less";
      folders = "du -h --max-depth=1";
      mountedinfo = "df -hT";
      duf = "duf -hide special";
      sha1 = "openssl sha1";
      own = "sudo chown -R $USER";
      fetch = "fastfetch -c my.jsonc";
      open = "xdg-open";

      # dev
      pyr = "python";
      gor = "go run";
      phs = "python -m http.server";
      phsd = "python -m http.server --directory";
    };

    promptInit = ''
      __kali_ps1() {
        GREEN="\[\e[1;32m\]"
        BLUE="\[\e[1;34m\]"
        RED="\[\e[1;31m\]"
        RESET="\[\e[0m\]"

        if [ "$EUID" -eq 0 ]; then
          COLOR="$RED"
          SYMBOL="#"
        else
          COLOR="$GREEN"
          SYMBOL="$"
        fi

        IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
        [ -z "$IP" ] && IP="no-ip"

        PS1="┌──$COLOR(\u㉿$IP)$RESET-$BLUE[\w]$RESET\n└─$COLOR$SYMBOL$RESET "
      }

      PROMPT_COMMAND=__kali_ps1

      # Kali-like history behavior
      HISTCONTROL=ignoreboth
      HISTSIZE=1000
      HISTFILESIZE=2000
      shopt -s histappend
      shopt -s checkwinsize

      export LESS="-R"
    '';
  };
}
