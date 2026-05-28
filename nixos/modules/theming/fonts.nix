{
  config,
  pkgs,
  lib,
  ...
}: let
  fontFamily = "JetBrainsMono Nerd Font";
in {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [fontFamily];
        sansSerif = [fontFamily];
        monospace = [fontFamily];
      };
    };
  };

  environment.sessionVariables = {
    FONT_FAMILY = fontFamily;
  };
}
