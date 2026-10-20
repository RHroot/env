{
  config,
  pkgs,
  ...
}:
let
  seriffont = "Merriweather";
  sansseriffont = "Noto Sans";
  emojiFont = "Noto Color Emoji";
  monospacefont = "FiraCode Nerd Font";

  cursorSize = 30;
  iconTheme = "Papirus-Dark";
  cursorTheme = "Bibata-Modern-Ice";
  themeName = "Flat-Remix-GTK-Violet-Darkest";
in
{
  programs.dconf.enable = true;

  fonts = {
    packages = with pkgs; [
      noto-fonts
      merriweather
      noto-fonts-emoji
      nerd-fonts.fira-code
    ];
    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
      hinting.style = "full";
      subpixel.rgba = "rgb";
      defaultFonts = {
        emoji = [ emojiFont ];
        serif = [ seriffont ];
        sansSerif = [ sansseriffont ];
        monospace = [ monospacefont ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    adwaita-qt
    bibata-cursors
    papirus-icon-theme
  ];
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${sansseriffont} 12
      gtk-cursor-theme-name=${cursorTheme}
      gtk-cursor-theme-size=${toString cursorSize}
      gtk-application-prefer-dark-theme=1
    '';

    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${sansseriffont} 12
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
    "/libexec"
    "/share/icons"
    "/share/themes"
  ];
}
