{
  config,
  pkgs,
  ...
}:
{
  services.xserver = {
    enable = true;
    wacom.enable = true;
    autoRepeatDelay = 150;
    autoRepeatInterval = 50;
    desktopManager = {
      xfce = {
        enable = true;
        enableXfwm = true;
      };
      xterm.enable = false;
    };

    displayManager.lightdm.enable = false;

    resolutions = [
      {
        x = 1920;
        y = 1080;
        rate = 60;
      }
    ];
  };

  services.displayManager.ly.enable = true;
  services.displayManager.gdm.enable = false;
  services.displayManager.sddm.enable = false;

  environment.systemPackages = with pkgs; [
    # === XOrg ===
    xev # Test key events (useful for config.h)
    xset # Keyboard repeat, mouse settings
    xrdb # Load Xresources
    xclip # X11 Clipboard
    xprop # Get window properties (for config.h rules)
    xrandr # Display resolution/monitor management
    xinput # Input device config
    xkill # Kill unresponsive windows
    xwininfo # Get window info
    xmessage # Display messages

    # === Utilities ===
    feh # Wallpaper manager/Image Viewer
    picom # Compositer for Screen Tearing
    dmenu # Application Launcher
  ];
}
