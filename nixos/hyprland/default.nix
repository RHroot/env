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

  security.polkit.enable = true;

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
    hyprsunset # Nightlight manager for Hyprland
    hyprpicker # Color picker for Wayland/Hyprland
    hyprcursor # Cursor theme support for Hyprland
    hyprpolkitagent # PolicyKit authentication agent for Hyprland
    hyprland-protocols # Wayland protocol extensions used by Hyprland

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
  ];
}
