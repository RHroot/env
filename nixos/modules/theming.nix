{
  config,
  pkgs,
  lib,
  ...
}: let
  themeName = "Flat-Remix-GTK-Magenta-Darkest";
  iconTheme = "Papirus-Dark";
  cursorTheme = "rose-pine-hyprcursor";
  cursorSize = 40;
  fontFamily = "FiraCode Nerd Font";
in {
  programs.dconf.enable = true;
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
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
  environment.systemPackages = with pkgs; [
    flat-remix-gtk
    papirus-icon-theme
    rose-pine-hyprcursor
    adwaita-icon-theme
  ];
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${fontFamily} 14
      gtk-cursor-theme-name=${cursorTheme}
      gtk-cursor-theme-size=${toString cursorSize}
      gtk-application-prefer-dark-theme=1
    '';

    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${fontFamily} 14
      gtk-cursor-theme-name=${cursorTheme}
      gtk-cursor-theme-size=${toString cursorSize}
      gtk-application-prefer-dark-theme=1
    '';
  };
  environment.sessionVariables = {
    GTK_THEME = themeName;
    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = toString cursorSize;
    NIXOS_OZONE_WL = "1";
  };
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  environment.pathsToLink = [
    "/share/icons"
    "/share/themes"
  ];
}
