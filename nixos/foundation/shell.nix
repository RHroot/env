{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    bat # cat replacement with syntax highlighting
    man # Manual page reader
    eza # Modern ls replacement with icons and git info
    tmux # Terminal multiplexer for managing multiple sessions
    bind # Command-line tools for DNS queries (dig, nslookup)
    lolcat # Colorful text output using rainbow gradients
    zoxide # Smarter cd command with directory jump history
    ripgrep # Fast recursive text search tool (rg)
    zsh-system-clipboard # Zsh plugin to sync clipboard with the system
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
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

    add_to_path "$HOME/.local/bin"

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

      # Navigation
      home = "cd ~";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      c = "clear";
      d = "z";
      pd = "cd -";

      # Editors
      v = "vim";
      n = "nvim";
      nv = "neovide";
      sv = "sudo vim";
      sn = "sudo nvim";

      # Tmux
      tns = "tmux new -s";
      ta = "tmux attach";
      td = "tmux detach";

      # System helpers
      ps = "ps auxf";
      less = "less -R";
      fdh = "fd --hidden";
      p = "ps aux | grep ";
      h = "history | grep ";
      fda = "fd --absolute-path";
      openports = "netstat -tulanp";
      fdah = "fd --absolute-path --hidden";
      topcpu = "ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10";

      # System control
      reboot = "systemctl reboot";
      shutdown = "shutdown now";
      logout = "loginctl kill-session $XDG_SESSION_ID";
      restart-dm = "sudo systemctl restart display-manager";

      # File operations
      cp = "cp -r";
      rmd = "rm -rfv";
      mkdir = "mkdir -p";
      img = "kitty +kitten icat";

      # Disk usage
      diskspace = "du -S | sort -n -r | less";
      folders = "du -h --max-depth=1";
      mountedinfo = "df -hT";
      duf = "duf -hide special";

      # Permissions & security
      mx = "chmod a+x";
      chmod000 = "chmod -R 000";
      chmod644 = "chmod -R 644";
      chmod666 = "chmod -R 666";
      chmod755 = "chmod -R 755";
      chmod777 = "chmod -R 777";
      sha1 = "openssl sha1";
      own = "sudo chown -R $USER";

      # Dev & tools
      grep = "grep --color=auto";
      rg = "rg --color=auto";
      myip = "curl ifconfig.me";
      bright = "brightnessctl set";
      oc = "opencode --port 3000";

      # Utilities;
      kssh = "kitty +kitten ssh";
      web = "cd /var/www/html";
      da = "date '+%Y-%m-%d %A %T %Z'";
      aria2-down = "aria2c --conf-path=$HOME/.config/aria2/aria2.conf";

      # System Information
      fetch = "fastfetch -c my.jsonc";
      open = "xdg-open";
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
