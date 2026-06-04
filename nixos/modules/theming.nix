{
  config,
  pkgs,
  lib,
  ...
}: let
  themeName = "Flat-Remix-GTK-Magenta-Darkest";
  iconTheme = "Papirus-Dark";
  cursorTheme = "Bibata-Modern-Ice";
  cursorSize = 30;
  seriffont = "Merriweather";
  sansseriffont = "Google Sans Flex";
  monospacefont = "FiraCode Nerd Font";
in {
  programs.dconf.enable = true;
  fonts = {
    packages = with pkgs; [
      merriweather
      google-sans-flex
      nerd-fonts.fira-code
    ];
    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
      hinting.style = "full";
      subpixel.rgba = "rgb";
      defaultFonts = {
        serif = [seriffont];
        sansSerif = [sansseriffont];
        monospace = [monospacefont];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    adwaita-qt
    bibata-cursors
    flat-remix-gtk
    papirus-icon-theme
    adwaita-icon-theme
  ];
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${sansseriffont} 11
      gtk-cursor-theme-name=${cursorTheme}
      gtk-cursor-theme-size=${toString cursorSize}
      gtk-application-prefer-dark-theme=1
    '';

    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${sansseriffont} 11
      gtk-cursor-theme-name=${cursorTheme}
      gtk-cursor-theme-size=${toString cursorSize}
      gtk-application-prefer-dark-theme=1
    '';
  };
  environment.sessionVariables = {
    GTK_THEME = themeName;
    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = toString cursorSize;
  };
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  environment.pathsToLink = [
    "/share/icons"
    "/share/themes"
  ];
}
