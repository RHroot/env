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
  fontFamily = "JetBrainsMono Nerd Font";
in {
  ########################################################
  # 1. REQUIRED: dconf (GTK reads from here on Wayland)
  ########################################################
  programs.dconf.enable = true;

  ########################################################
  # 2. Fonts (Force JetBrains everywhere via fontconfig)
  ########################################################
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

  ########################################################
  # 3. Install Theme Assets
  ########################################################
  environment.systemPackages = with pkgs; [
    flat-remix-gtk
    papirus-icon-theme
    rose-pine-hyprcursor
    adwaita-icon-theme
  ];

  ########################################################
  # 4. System-wide GTK config (fallback layer)
  ########################################################
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

  ########################################################
  # 5. Wayland Session Variables (Hyprland critical)
  ########################################################
  environment.sessionVariables = {
    GTK_THEME = themeName;
    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = toString cursorSize;

    # Make Electron behave correctly on Wayland
    NIXOS_OZONE_WL = "1";
  };

  ########################################################
  # 6. Qt Integration (NO GNOME session required)
  ########################################################
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita";
  };

  ########################################################
  # 7. Hyprland Wayland portal (REQUIRED)
  ########################################################
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  ########################################################
  # 8. Optional safety: ensure GTK icon lookup works
  ########################################################
  environment.pathsToLink = [
    "/share/icons"
    "/share/themes"
  ];
}
