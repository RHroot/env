{
  config,
  pkgs,
  lib,
  ...
}: let
  palette = config.palette.semantic;
  colors = config.palette;

  gtkSettings = {
    gtk_theme_name = "Custom-Grayscale";
    gtk_icon_theme_name = "Papirus-Dark";
    gtk_cursor_theme_name = "Vimix-cursors";
    gtk_cursor_theme_size = 40;
    gtk_font_name = "JetBrainsMono Nerd Font 14";
    gtk_application_prefer_dark_theme = 1;
    gtk_enable_animations = 0;
  };

  gtkCss = pkgs.writeText "gtk.css" ''
    /* Auto-generated from palette.nix */
    window, .background {
      background-color: ${palette.window_bg};
      color: ${palette.window_fg};
    }

    button {
      background-color: ${palette.button_bg};
      color: ${palette.button_fg};
      border: 1px solid ${colors.border.medium};
    }

    button:hover {
      background-color: ${palette.button_hover_bg};
    }

    button:active {
      background-color: ${palette.button_active_bg};
    }

    entry {
      background-color: ${palette.input_bg};
      color: ${palette.input_fg};
      border-color: ${palette.input_border};
    }

    .sidebar {
      background-color: ${palette.sidebar_bg};
      color: ${palette.sidebar_fg};
    }

    *:selected {
      background-color: ${palette.selection_bg};
      color: ${palette.selection_fg};
    }

    scrollbar slider {
      background-color: ${palette.scrollbar_fg};
    }

    scrollbar slider:hover {
      background-color: ${palette.scrollbar_hover};
    }
  '';

  generatedTheme = pkgs.runCommand "custom-grayscale-theme" {} ''
    mkdir -p $out/share/themes/Custom-Grayscale/gtk-3.0
    mkdir -p $out/share/themes/Custom-Grayscale/gtk-4.0

    # Copy base theme structure
    cp -r ${pkgs.gnome-themes-extra}/share/themes/Adwaita-dark/gtk-3.0/* $out/share/themes/Custom-Grayscale/gtk-3.0/ 2>/dev/null || true
    cp -r ${pkgs.gnome-themes-extra}/share/themes/Adwaita-dark/gtk-4.0/* $out/share/themes/Custom-Grayscale/gtk-4.0/ 2>/dev/null || true

    # Override with our CSS
    cp ${gtkCss} $out/share/themes/Custom-Grayscale/gtk-3.0/gtk.css
    cp ${gtkCss} $out/share/themes/Custom-Grayscale/gtk-4.0/gtk.css

    cat > $out/share/themes/Custom-Grayscale/index.theme << EOF
    [Desktop Entry]
    Type=X-GNOME-Metatheme
    Name=Custom Grayscale
    Comment=Pure grayscale theme
    Encoding=UTF-8

    [X-GNOME-Metatheme]
    GtkTheme=Custom-Grayscale
    IconTheme=Papirus-Dark
    CursorTheme=Vimix-cursors
    EOF
  '';
in {
  environment.systemPackages = [generatedTheme pkgs.papirus-icon-theme pkgs.vimix-cursors];

  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name}=${toString value}") gtkSettings)}
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name}=${toString value}") gtkSettings)}
    '';
  };

  environment.sessionVariables = {
    GTK_THEME = "Custom-Grayscale";
    XCURSOR_THEME = "Vimix-cursors";
    XCURSOR_SIZE = "40";
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
