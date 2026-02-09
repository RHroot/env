{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./audio.nix
    ./video.nix
    ./content.nix
    ./theming.nix
    ./graphics.nix
    ./toolbox.nix
    ./windowmanager.nix
  ];
}
