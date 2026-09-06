{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    git
    delta
  ];

  programs.ssh.startAgent = true;
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  programs.git = {
    enable = true;

    config = {
      gpg.format = "ssh";
      commit.gpgsign = true;

      core = {
        editor = "vi";
        pager = "delta";
        autocrlf = "input";
      };

      interactive.diffFilter = "delta --color-only";

      delta = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
        syntax-theme = "Dracula";
        hyperlinks = true;
      };

      diff.colorMoved = "default";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "current";
      color.ui = "auto";
    };
  };
}
