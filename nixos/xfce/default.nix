{
  config,
  pkgs,
  lib,
  ...
}: {
  # === DISPLAY MANAGER (LightDM) ===
  services.xserver = {
    enable = lib.mkForce true;

    # Enable LightDM as the display manager
    displayManager = {
      lightdm = {
        enable = lib.mkForce true;
      };
      # Set Xfce as the default session
      defaultSession = lib.mkForce "xfce";
    };

    # === XFCE DESKTOP ENVIRONMENT ===
    desktopManager = {
      xfce = {
        enable = lib.mkForce true;
        # Enable Xfce's built-in compositor (lightweight, no extra package needed)
        enableXfwm = lib.mkForce true;
      };
      # Disable the default xterm that comes with Xorg
      xterm.enable = lib.mkForce false;
    };
  };

  # === EXTRA XFCE APPLICATIONS ===
  environment.systemPackages = with pkgs; [
    # Core Xfce utilities that aren't installed by default
    xfce.ristretto # Image viewer
    xfce.parole # Media player
    xfce.orage # Calendar
    xfce.mousepad # Text editor

    # Thunar plugins for better file management
    xfce.thunar-archive-plugin # Archive extraction in Thunar
    xfce.thunar-volman # Volume management for Thunar
  ];
}
