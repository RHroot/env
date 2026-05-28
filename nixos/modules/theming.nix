{
  config,
  pkgs,
  lib,
  ...
}: let
  # Define your palette once here
  palette = {
    bg = {
      darkest = "#000000";
      darker = "#0a0a0a";
      dark = "#111111";
      medium = "#1a1a1a";
      light = "#222222";
      lighter = "#2a2a2a";
      lightest = "#333333";
    };

    fg = {
      brightest = "#ffffff";
      brighter = "#e0e0e0";
      bright = "#c0c0c0";
      medium = "#a0a0a0";
      dark = "#808080";
      darker = "#606060";
      darkest = "#404040";
    };

    border = {
      light = "#444444";
      medium = "#333333";
      dark = "#222222";
    };

    semantic = {
      window_bg = "#000000";
      window_fg = "#ffffff";
      panel_bg = "#0a0a0a";
      panel_fg = "#e0e0e0";
      button_bg = "#1a1a1a";
      button_fg = "#ffffff";
      button_hover_bg = "#2a2a2a";
      button_active_bg = "#0a0a0a";
      input_bg = "#111111";
      input_fg = "#ffffff";
      input_border = "#333333";
      selection_bg = "#333333";
      selection_fg = "#ffffff";
      scrollbar_bg = "#0a0a0a";
      scrollbar_fg = "#444444";
      scrollbar_hover = "#666666";
      terminal_bg = "#000000";
      terminal_fg = "#ffffff";
      sidebar_bg = "#0a0a0a";
      sidebar_fg = "#c0c0c0";
      status_good = "#888888";
      status_warning = "#aaaaaa";
      status_error = "#dddddd";
    };
  };

  # GTK CSS generated from palette
  gtkCss = pkgs.writeText "gtk.css" ''
    window, .background {
      background-color: ${palette.semantic.window_bg};
      color: ${palette.semantic.window_fg};
    }

    button {
      background-color: ${palette.semantic.button_bg};
      color: ${palette.semantic.button_fg};
      border: 1px solid ${palette.border.medium};
    }

    button:hover {
      background-color: ${palette.semantic.button_hover_bg};
    }

    button:active {
      background-color: ${palette.semantic.button_active_bg};
    }

    entry {
      background-color: ${palette.semantic.input_bg};
      color: ${palette.semantic.input_fg};
      border-color: ${palette.semantic.input_border};
    }

    .sidebar {
      background-color: ${palette.semantic.sidebar_bg};
      color: ${palette.semantic.sidebar_fg};
    }

    *:selected {
      background-color: ${palette.semantic.selection_bg};
      color: ${palette.semantic.selection_fg};
    }

    scrollbar slider {
      background-color: ${palette.semantic.scrollbar_fg};
    }

    scrollbar slider:hover {
      background-color: ${palette.semantic.scrollbar_hover};
    }
  '';

  # GTK Theme package
  grayscaleTheme = pkgs.runCommand "grayscale-theme" {} ''
    mkdir -p $out/share/themes/Grayscale/gtk-3.0
    mkdir -p $out/share/themes/Grayscale/gtk-4.0

    cp ${gtkCss} $out/share/themes/Grayscale/gtk-3.0/gtk.css
    cp ${gtkCss} $out/share/themes/Grayscale/gtk-4.0/gtk.css

    cat > $out/share/themes/Grayscale/index.theme << EOF
    [Desktop Entry]
    Type=X-GNOME-Metatheme
    Name=Grayscale
    Comment=Pure grayscale theme
    Encoding=UTF-8

    [X-GNOME-Metatheme]
    GtkTheme=Grayscale
    IconTheme=Papirus-Dark
    CursorTheme=Vimix-cursors
    EOF
  '';

  # Kitty config
  kittyConf = pkgs.writeText "kitty.conf" ''
    background ${palette.semantic.terminal_bg}
    foreground ${palette.semantic.terminal_fg}

    color0  ${palette.bg.darkest}
    color1  ${palette.fg.darker}
    color2  ${palette.fg.dark}
    color3  ${palette.fg.medium}
    color4  ${palette.fg.bright}
    color5  ${palette.fg.brighter}
    color6  ${palette.fg.brightest}
    color7  ${palette.fg.brightest}
    color8  ${palette.bg.darker}
    color9  ${palette.fg.medium}
    color10 ${palette.fg.bright}
    color11 ${palette.fg.brighter}
    color12 ${palette.fg.brightest}
    color13 ${palette.fg.brightest}
    color14 ${palette.fg.brightest}
    color15 ${palette.fg.brightest}

    cursor ${palette.semantic.terminal_fg}
    cursor_text_color ${palette.semantic.terminal_bg}
    selection_background ${palette.semantic.selection_bg}
    selection_foreground ${palette.semantic.selection_fg}

    font_family JetBrainsMono Nerd Font
    font_size 12
    background_opacity 0.95
    tab_bar_style hidden
  '';

  # Rofi config
  rofiTheme = pkgs.writeText "grayscale.rasi" ''
    * {
        background-color: ${palette.semantic.window_bg};
        text-color: ${palette.semantic.window_fg};
        selected-bg: ${palette.semantic.selection_bg};
        selected-fg: ${palette.semantic.selection_fg};
    }

    window {
        background-color: background-color;
        border: 1px solid ${palette.border.medium};
    }

    element selected {
        background-color: selected-bg;
        text-color: selected-fg;
    }
  '';
in {
  # Fonts
  fonts = {
    packages = with pkgs; [nerd-fonts.jetbrains-mono];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font"];
      };
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    grayscaleTheme
    papirus-icon-theme
    vimix-cursors
  ];

  # GTK Settings
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Grayscale
      gtk-icon-theme-name=Papirus-Dark
      gtk-cursor-theme-name=Vimix-cursors
      gtk-cursor-theme-size=40
      gtk-font-name=JetBrainsMono Nerd Font 12
      gtk-application-prefer-dark-theme=1
      gtk-enable-animations=0
    '';

    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Grayscale
      gtk-icon-theme-name=Papirus-Dark
      gtk-cursor-theme-name=Vimix-cursors
      gtk-cursor-theme-size=40
      gtk-font-name=JetBrainsMono Nerd Font 12
      gtk-application-prefer-dark-theme=1
    '';

    "kitty/kitty.conf".source = kittyConf;
    "rofi/grayscale.rasi".source = rofiTheme;
  };

  # Session variables
  environment.sessionVariables = {
    GTK_THEME = "Grayscale";
    XCURSOR_THEME = "Vimix-cursors";
    XCURSOR_SIZE = "40";
    ROFI_THEME = "/etc/rofi/grayscale.rasi";
    KITTY_CONFIG_DIRECTORY = "/etc/kitty";
  };

  # QT theming
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
