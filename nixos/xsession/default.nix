{
  config,
  pkgs,
  ...
}:
{
  services.xserver = {
    enable = true;
    wacom.enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 40;
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
    xset # Keyboard repeat, mouse settings
    xrandr # Display resolution/monitor management
  ];
}
