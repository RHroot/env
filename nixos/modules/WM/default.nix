{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./graphics.nix
    ./hyprland.nix
  ];
}
