{
  config,
  pkgs,
  lib,
  ...
}: let
  gitUsers = ["sten"];
in {
  environment.systemPackages = with pkgs; [
    git
    delta
  ];

  system.activationScripts.gitSetup = lib.mkAfter ''
        for u in ${lib.concatStringsSep " " gitUsers}; do
          if [ "$u" = "root" ]; then continue; fi

          userHome=$(getent passwd "$u" | cut -d: -f6)
          [ -z "$userHome" ] && continue

          gitMain="$userHome/.gitconfig"
          gitWork="$userHome/.gitconfig-work"

          # ---------------------------
          # MAIN CONFIG (PUBLIC SAFE)
          # ---------------------------
          cat > "$gitMain" <<EOF
    # Load private identity (not tracked in repo)
    [include]
        path = ~/.gitconfig-local

    # Load work identity only for work remotes
    [includeIf "hasconfig:remote.origin.url:github-work:"]
        path = ~/.gitconfig-work
    [includeIf "hasconfig:remote.origin.url:gitlab-work:"]
        path = ~/.gitconfig-work

    [gpg]
        format = ssh

    [commit]
        gpgsign = true

    [core]
        editor = nvim
        pager = delta
        autocrlf = input

    [interactive]
        diffFilter = delta --color-only

    [delta]
        navigate = true
        line-numbers = true
        side-by-side = true
        syntax-theme = Dracula
        hyperlinks = true

    [diff]
        colorMoved = default

    [init]
        defaultBranch = main

    [pull]
        rebase = true

    [push]
        default = current

    [color]
        ui = auto
    EOF

          # ---------------------------
          # WORK IDENTITY (SAFE TO EDIT LOCALLY)
          # ---------------------------
          if [ ! -f "$gitWork" ]; then
            cat > "$gitWork" <<EOF
    # Define work identity locally (not committed)
    [user]
        name = WORK_NAME
        email = WORK_EMAIL
    EOF
          fi

          chown "$u:users" "$gitMain" "$gitWork"
        done
  '';
}
