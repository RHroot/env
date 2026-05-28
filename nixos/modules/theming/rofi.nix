{
  config,
  pkgs,
  lib,
  ...
}: let
  palette = config.palette.semantic;
  colors = config.palette;

  rofiTheme = pkgs.writeText "grayscale.rasi" ''
    * {
        background-color: ${palette.window_bg};
        text-color: ${palette.window_fg};

        bg0: ${colors.bg.darker};
        bg1: ${colors.bg.dark};
        bg2: ${colors.bg.medium};

        selected-bg: ${palette.selection_bg};
        selected-fg: ${palette.selection_fg};
    }

    window {
        background-color: background-color;
        border: 1px solid ${colors.border.medium};
    }

    element selected {
        background-color: selected-bg;
        text-color: selected-fg;
    }
  '';
in {
  environment.etc."rofi/grayscale.rasi".source = rofiTheme;

  environment.sessionVariables = {
    ROFI_THEME = "/etc/rofi/grayscale.rasi";
  };
}
