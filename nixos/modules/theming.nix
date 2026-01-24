{
  config,
  pkgs,
  ...
}: let
  themeName = "Flat-Remix-GTK-Magenta-Darkest";
  iconTheme = "Papirus-Dark";
  gtkFont = "JetBrainsMono Nerd Font 14";
  cursorTheme = "rose-pine-hyprcursor";
in {
  fonts.fontconfig.defaultFonts = {
    sansSerif = ["Sans"];
    serif = ["Serif"];
    monospace = ["JetBrainsMono Nerd Font"];
  };
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  environment.systemPackages = with pkgs; [
    gtk3 # GTK+ 3 toolkit for graphical applications
    flat-remix-gtk # Flat Remix GTK theme for GTK-based apps
    papirus-icon-theme # Papirus SVG-based icon theme
    rose-pine-hyprcursor # Rose Pine cursor theme for Hyprland
  ];

  environment.pathsToLink = [
    "/lib"
    "/bin"
    "/sbin"
    "/include"
    "/libexec"
    "/share/man"
    "/share/mime"
    "/share/fonts"
    "/share/icons"
    "/share/pixmaps"
    "/share/metainfo"
    "/share/applications"
    "/share/desktop-directories"
  ];

  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${gtkFont}
      gtk-cursor-theme-name=${cursorTheme}
      gtk-cursor-theme-size=40
      gtk-application-prefer-dark-theme=1
    '';

    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${gtkFont}
      gtk-cursor-theme-name=${cursorTheme}
      gtk-cursor-theme-size=40
      gtk-application-prefer-dark-theme=1
    '';
  };

  environment.sessionVariables = {
    GTK_THEME = themeName;
  };
}
