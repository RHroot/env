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
    ./development.nix
    ./windowmanager.nix
  ];
}
