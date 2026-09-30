{
  config,
  pkgs,
  ...
}:
{
  programs.niri = {
    enable = true;
  };

  xdg.portal.enable = true;

  environment.systemPackages = with pkgs; [
    imv # Image Viewer
    dunst # Notification daemon
    kitty # Feature-rich GPU-based terminal emulator
    cliphist # Clipboard manager for Wayland
    libinput # Input device management library
    alacritty # Rust based fast terminal emulator
    playerctl # Media player control via MPRIS
    wl-clipboard # Clipboard utilities for Wayland
    xwayland-satellite # Xwayland for niri works out of the box
  ];

  xdg.mime.defaultApplications = {
    # Images
    "image/png" = [ "imv.desktop" ];
    "image/jpeg" = [ "imv.desktop" ];
    "image/webp" = [ "imv.desktop" ];
    "image/gif" = [ "imv.desktop" ];
  };
}
