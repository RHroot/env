{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = false;
    autoRepeatDelay = 200;
    autoRepeatInterval = 50;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.displayManager.ly.enable = false;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "sten";
      };
    };
  };
  services.displayManager.defaultSession = "Hyprland";
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables = {
    WAYLAND_DISPLAY = "wayland-0";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };
  programs.hyprlock.enable = true;
  programs.waybar.enable = true;
  services.hypridle.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  # Enable polkit for GUI privilege prompts
  security.polkit.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
  };
  environment.systemPackages = with pkgs; [
    # === HYPRLAND ===
    hyprland # Wayland compositor for dynamic tiling (Hyprland)
    hyprcursor # Cursor theme support for Hyprland
    hypridle # Idle management daemon for Hyprland
    hyprland-protocols # Wayland protocol extensions used by Hyprland
    hyprland-qt-support # Qt integration support for Hyprland
    hyprland-qtutils # Qt utilities for Hyprland components
    hyprlock # Screen locker for Hyprland
    hyprpicker # Color picker for Wayland/Hyprland
    hyprshot # Screenshot utility for Hyprland
    wlroots_0_19 # Wayland compositor library required by Hyprland

    # === basic ===
    libnotify # Desktop notification library
    dunst # Lightweight notification daemon
    waybar # Status bar for Wayland compositors
    swww # Wayland wallpaper daemon with transitions
    wl-clipboard # Clipboard utilities for Wayland
    playerctl # Media player control via MPRIS
    fuzzel # Wayland-native application launcher (rofi alternative)

    # === Theming ===
    matugen # Generate color schemes from images
    wallust # Dynamic color generation based on wallpapers

    # === Terminal emulators ===
    alacritty # GPU-accelerated terminal emulator
    kitty # Feature-rich GPU-based terminal emulator

    # === Zathura ===
    zathura # Minimal PDF and document viewer
    poppler # PDF rendering backend used by viewers
    ps # PostScript interpreter and utilities

    # === File managers ===
    nautilus # GNOME file manager

    # === Polkit ===
    kdePackages.polkit-kde-agent-1 # PolicyKit authentication agent for Wayland

    # === Utility ===
    telegram-desktop # Telegram messaging desktop client
    appflowy # Open-source Notion-style productivity app
    libreoffice-fresh # Full-featured office suite (latest stable)
    evince # Document viewer for PDF and other formats
  ];
}
