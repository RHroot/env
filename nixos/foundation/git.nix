{
  config,
  pkgs,
  lib,
  ...
}: let
  user = "sten";

  identities = {
    rhroot = {
      name = "RHroot";
      email = "rhroot@example.com";
      signingKey = "~/.ssh/id_ed25519_rhroot";
    };

    rixspace = {
      name = "rixspace";
      email = "rixspace@example.com";
      signingKey = "~/.ssh/id_ed25519_rixspace";
    };
  };
in {
  environment.systemPackages = with pkgs; [
    git
    delta
    openssh
  ];

  # -----------------------------
  # SSH CONFIG (User-level via etc)
  # -----------------------------
  environment.etc."ssh/ssh_config.d/sten-multi.conf".text = ''
    Host github-rhroot
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519_rhroot
        IdentitiesOnly yes

    Host github-rixspace
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519_rixspace
        IdentitiesOnly yes

    Host gitlab-rhroot
        HostName gitlab.com
        User git
        IdentityFile ~/.ssh/id_ed25519_rhroot
        IdentitiesOnly yes

    Host gitlab-rixspace
        HostName gitlab.com
        User git
        IdentityFile ~/.ssh/id_ed25519_rixspace
        IdentitiesOnly yes
  '';

  # -----------------------------
  # Global Git Config
  # -----------------------------
  environment.etc."gitconfig".text = ''
    [core]
        editor = nvim
        pager = delta
        autocrlf = input

    [interactive]
        diffFilter = delta --color-only

    [delta]
        navigate = true
        side-by-side = true
        line-numbers = true
        syntax-theme = Dracula

    [pull]
        rebase = true

    [push]
        default = current

    [init]
        defaultBranch = main

    [includeIf "gitdir:~/projects/rhroot/"]
        path = ~/.gitconfig-rhroot

    [includeIf "gitdir:~/projects/rixspace/"]
        path = ~/.gitconfig-rixspace
  '';

  # -----------------------------
  # Per-Identity Git Config Files
  # -----------------------------
  users.users.${user}.packages = [];

  users.users.${user}.shellInit = ''
        # Ensure identity configs exist
        if [ ! -f ~/.gitconfig-rhroot ]; then
          cat > ~/.gitconfig-rhroot <<EOF
    [user]
        name = ${identities.rhroot.name}
        email = ${identities.rhroot.email}
        signingkey = ${identities.rhroot.signingKey}

    [commit]
        gpgsign = true
    EOF
        fi

        if [ ! -f ~/.gitconfig-rixspace ]; then
          cat > ~/.gitconfig-rixspace <<EOF
    [user]
        name = ${identities.rixspace.name}
        email = ${identities.rixspace.email}
        signingkey = ${identities.rixspace.signingKey}

    [commit]
        gpgsign = true
    EOF
        fi
  '';
}
