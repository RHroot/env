{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./audio.nix
    ./video.nix
    ./theming.nix
    ./graphics.nix
    ./development.nix
    ./windowmanager.nix
  ];
}
