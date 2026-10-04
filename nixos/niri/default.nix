{
  config,
  pkgs,
  ...
}:
{
  programs.niri = {
    enable = true;
  };

  programs.xwayland = {
    enable = true;
    package = pkgs.xwayland-satellite;
  };

  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    enableX11 = true;
    enableWayland = true;
  };

  xdg.portal.enable = true;

  environment.systemPackages = with pkgs; [
    imv # Image Viewer
    rofi # Very dynamic launcher
    kitty # Feature-rich GPU-based terminal emulator
    swaybg # Lightweight wallpaper manager
    swayidle # Idle manager
    cliphist # Clipboard manager for Wayland
    alacritty # Rust based fast terminal emulator
    playerctl # Media player control via MPRIS
    wl-clipboard # Clipboard utilities for Wayland
    swaylock-effects # Lightweight session locker
  ];

  xdg.mime.defaultApplications = {
    # Images
    "image/png" = [ "imv.desktop" ];
    "image/jpeg" = [ "imv.desktop" ];
    "image/webp" = [ "imv.desktop" ];
    "image/gif" = [ "imv.desktop" ];
  };
}
