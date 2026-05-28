{...}: {
  # Pure grayscale palette - single source of truth
  palette = {
    # Backgrounds (darkest to lightest)
    bg = {
      darkest = "#000000"; # Pure black
      darker = "#0a0a0a";
      dark = "#111111";
      medium = "#1a1a1a";
      light = "#222222";
      lighter = "#2a2a2a";
      lightest = "#333333";
    };

    # Foregrounds (lightest to darkest)
    fg = {
      brightest = "#ffffff"; # Pure white
      brighter = "#e0e0e0";
      bright = "#c0c0c0";
      medium = "#a0a0a0";
      dark = "#808080";
      darker = "#606060";
      darkest = "#404040";
    };

    # Borders and accents
    border = {
      light = "#444444";
      medium = "#333333";
      dark = "#222222";
    };

    # Semantic aliases (what each color is used for)
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
}
