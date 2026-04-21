{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./dwl.nix
  ];
}
