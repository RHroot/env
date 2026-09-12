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
    windowManager = {
      i3 = {
        enable = true;
      };
    };
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

  programs.i3lock = {
    enable = true;
    package = pkgs.i3lock-color;
  };

  xdg.mime.defaultApplications = {
    # Images
    "image/png" = [ "feh.desktop" ];
    "image/jpeg" = [ "feh.desktop" ];
    "image/webp" = [ "feh.desktop" ];
    "image/gif" = [ "feh.desktop" ];
    # File manager
    "inode/directory" = [ "pcmanfm.desktop" ];
  };

  environment.systemPackages = with pkgs; [
    xset
    xclip
    xrandr
    xidlehook
    xdotool

    feh
    maim
    picom
    dmenu
    dunst
    pcmanfm
    clipmenu
    libinput
    playerctl
    libinput-gestures
  ];
}
