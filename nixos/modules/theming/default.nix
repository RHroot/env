{
  config,
  pkgs,
  lib,
  ...
}: let
  paletteModule = import ./palette.nix;
in {
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./kitty.nix
    ./rofi.nix
  ];

  # Make palette available to all submodules
  config.palette = paletteModule.palette;
}
