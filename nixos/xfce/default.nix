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

  # Set Xfce as the default session
  services.displayManager.defaultSession = lib.mkForce "xfce";

  # === EXTRA XFCE APPLICATIONS ===
  environment.systemPackages = with pkgs; [
    # Core Xfce utilities that aren't installed by default
    ristretto # Image viewer
    parole # Media player
    orage # Calendar
    mousepad # Text editor
    google-chrome # Web browser
  ];
}
