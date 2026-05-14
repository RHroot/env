{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./audio.nix
    ./video.nix
    ./gaming.nix
    ./content.nix
    ./utility.nix
    ./theming.nix
    ./toolbox.nix
    ./graphics.nix
    ./WM
  ];
}
