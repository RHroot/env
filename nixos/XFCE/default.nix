{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    resolutions = [
      {
        x = 1920;
        y = 1080;
      }
    ];
    displayManager.lightdm = {
      enable = true;
      greeter.setupScript = "${pkgs.xorg.xrandr}/bin/xrandr --output $( ${pkgs.xorg.xrandr}/bin/xrandr | awk '/ connected/ {print $1; exit}' ) --mode 1920x1080 --rate 60.00";
    };
  };

  services.displayManager.gdm.enable = false;
  services.displayManager.sddm.enable = false;

  environment.systemPackages = with pkgs; [
    google-chrome
  ];
}
