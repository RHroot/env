{
  config,
  pkgs,
  ...
}:
{
  programs.fish.enable = true;
  programs.starship.enable = true;

  programs.bash = {
    enable = true;
    completion.enable = true;

    shellAliases = {
      # Navigation
      d = "z";
      pd = "cd -";
      c = "clear";
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
      diskspace = "du -S | sort -n -r | less";

      # Permissions & security
      sha1 = "openssl sha1";
      own = "sudo chown -R $USER";

      # Dev & tools
      ga = "git add";
      gp = "git push";
      gd = "git diff";
      gs = "git status";
      rg = "rg --color=auto";
      myip = "curl ifconfig.me";
      grep = "grep --color=auto";
      oc = "opencode --port 3000";
      bright = "brightnessctl set";
      nettest = "nix shell nixpkgs#speedtest-go --command speedtest-go";
      antigravity = "nix run github:jacopone/antigravity-nix#google-antigravity-cli";

      # Utilities
      ff = "fastfetch -c my.jsonc";
      wget = "wget -c --limit-rate=15m";

      # System Information
      open = "xdg-open";
      vol = "wpctl get-volume @DEFAULT_AUDIO_SINK@";

      # LS commands
      ls = "ls --hyperlink=auto";
      la = "ls -A --hyperlink=auto";
      lz = "ls -lhAi --hyperlink=auto";
      lh = "ls -d .* 2>/dev/null --hyperlink=auto";
      tree = "tree -a 2>/dev/null || ls -R --color=auto";
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

  documentation = {
    enable = true;
    man.enable = true;
  };

  environment.systemPackages = with pkgs; [
    fish # User-friendly shell with powerful features and plugins
    bind # Command-line tools for DNS queries (dig, nslookup)
    lolcat # Colorful text output using rainbow gradients
    zoxide # Smarter cd command with directory jump history
    ripgrep # Fast recursive text search tool (rg)
    starship # Customizable prompt for various shells with git info and more
  ];

  environment.sessionVariables = {
    PAGER = "less";
    COLORTERM = "truecolor";

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";

    LESSHISTFILE = "$HOME/.cache/less_history";
    PYTHON_HISTORY = "$HOME/.local/share/python/history";
  };

  environment.localBinInPath = true;
}
