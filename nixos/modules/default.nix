{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./audio.nix
    ./video.nix
    ./content.nix
    ./utility.nix
    ./theming.nix
    ./graphics.nix
    ./toolbox.nix
    ./windowmanager
  ];
}
