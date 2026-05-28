{
  config,
  pkgs,
  lib,
  ...
}: let
  palette = config.palette.semantic;
  colors = config.palette;

  kittyConf = pkgs.writeText "kitty.conf" ''
    # Auto-generated from palette.nix
    background ${palette.terminal_bg}
    foreground ${palette.terminal_fg}

    color0  ${colors.bg.darkest}
    color1  ${colors.fg.darker}
    color2  ${colors.fg.dark}
    color3  ${colors.fg.medium}
    color4  ${colors.fg.bright}
    color5  ${colors.fg.brighter}
    color6  ${colors.fg.brightest}
    color7  ${colors.fg.brightest}
    color8  ${colors.bg.darker}
    color9  ${colors.fg.medium}
    color10 ${colors.fg.bright}
    color11 ${colors.fg.brighter}
    color12 ${colors.fg.brightest}
    color13 ${colors.fg.brightest}
    color14 ${colors.fg.brightest}
    color15 ${colors.fg.brightest}

    cursor ${palette.terminal_fg}
    cursor_text_color ${palette.terminal_bg}
    selection_background ${palette.selection_bg}
    selection_foreground ${palette.selection_fg}

    font_family JetBrainsMono Nerd Font
    font_size 12
    background_opacity 0.95
    tab_bar_style hidden
  '';
in {
  environment.etc."kitty/kitty.conf".source = kittyConf;

  environment.sessionVariables = {
    KITTY_CONFIG_DIRECTORY = "/etc/kitty";
  };
}
