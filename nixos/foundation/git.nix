{
  config,
  pkgs,
  lib,
  ...
}: let
  gitUsers = ["sten"];
  gitUserName = "RHroot";
  gitSigningKeyRelative = ".ssh/id_ed25519";
in {
  environment.systemPackages = with pkgs; [
    git # Distributed version control system
    delta # Syntax-highlighted pager for git diffs
    openssh # OpenSSH client and server for secure remote access
  ];
  system.activationScripts.gitConfigUsers = lib.mkAfter ''
        for u in ${lib.concatStringsSep " " gitUsers}; do
          # skip root if accidentally included
          if [ "$u" = "root" ]; then continue; fi

          # get home directory dynamically
          userHome=$(getent passwd "$u" | cut -d: -f6)
          if [ -z "$userHome" ]; then
            echo "Warning: user $u not found, skipping .gitconfig"
            continue
          fi

          gitConfigFile="$userHome/.gitconfig"

          # create .gitconfig
          mkdir -p "$userHome"
          cat > "$gitConfigFile" <<EOF
    [user]
        name = ${gitUserName}
        signingkey = \$HOME/${gitSigningKeyRelative}

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

          # set ownership and permissions
          chown "$u:users" "$gitConfigFile"
        done
  '';
}
