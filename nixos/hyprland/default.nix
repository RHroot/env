{
  config,
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };

  programs.hyprlock.enable = true;

  # Enable polkit for GUI privilege prompts
  security.polkit.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_DBUS_REMOTE = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WAYLAND_USE_VAAPI = "1";
    WAYLAND_DISPLAY = "wayland-0";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  xdg.mime.defaultApplications = {
    # Images
    "image/png" = [ "imv.desktop" ];
    "image/jpeg" = [ "imv.desktop" ];
    "image/webp" = [ "imv.desktop" ];
    "image/gif" = [ "imv.desktop" ];
    # File manager
    "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
  };

  environment.systemPackages = with pkgs; [
    # === HYPRLAND ===
    hyprlock # Screen locker for Hyprland
    hyprshot # Screenshot utility for Hyprland
    hyprpicker # Color picker for Wayland/Hyprland
    hyprcursor # Cursor theme support for Hyprland
    hyprland-qtutils # Qt utilities for Hyprland components
    hyprland-protocols # Wayland protocol extensions used by Hyprland
    hyprland-qt-support # Qt integration support for Hyprland

    # === basic ===
    imv # Image viewer for Wayland
    rofi # Application launcher and dmenu replacement
    dunst # Lightweight notification daemon
    cliphist # Clipboard manager for Wayland
    libinput # Input device management library
    playerctl # Media player control via MPRIS
    libnotify # Desktop notification library
    wl-clipboard # Clipboard utilities for Wayland

    # === Wallpaper ===
    swaybg # Wallpaper manager for Wayland compositors
    waypaper # Wallpaper manager for Wayland compositors

    # === Theming ===
    matugen # Generate color schemes from images

    # === Terminal emulators ===
    kitty # Feature-rich GPU-based terminal emulator
    alacritty # GPU-accelerated terminal emulator

    # === File managers ===
    nautilus # GNOME file manager

    # === Polkit ===
    kdePackages.polkit-kde-agent-1 # PolicyKit authentication agent for Wayland

    # === XDG ===
    xdg-utils # Desktop integration helpers (xdg-open, etc.)
    xdg-desktop-portal # XDG desktop portal service
    xdg-desktop-portal-hyprland # XDG portal backend for Hyprland
  ];
}
