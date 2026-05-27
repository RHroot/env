{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      # configFile = "/home/sten/env/.config/qtile/config.py";
    };
    displayManager.lightdm.enable = false;
  };

  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";
    fade = false;
    shadow = false;
  };

  services.libinput = {
    enable = true;

    touchpad = {
      disableWhileTyping = true;
      tapping = true;
      naturalScrolling = false;

      clickMethod = "clickfinger"; # better multi-finger clicks
      scrollMethod = "twofinger"; # standard
      accelProfile = "flat"; # or "adaptive"
      accelSpeed = "0.4"; # range: -1 to 1

      middleEmulation = true; # 3-finger middle click
    };

    mouse = {
      accelProfile = "flat";
      accelSpeed = "0.0";
      middleEmulation = true;
    };
  };

  services.displayManager.gdm.enable = false;
  services.displayManager.sddm.enable = false;

  services.getty.autologinUser = "sten";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "qtile";
        user = "sten";
      };
    };
  };

  services.displayManager.defaultSession = "qtile";

  xdg.portal = {
    enable = true;
    configPackages = [pkgs.xdg-desktop-portal-gtk];
  };

  environment.systemPackages = with pkgs; [
    # === Qtile ===
    python313Packages.qtile # Qtile core
    python313Packages.qtile-extras # Qtile extras
    picom # X compositor

    # === Basic ===
    libinput # Input device management library
    playerctl # Media player control via MPRIS
    libnotify # Desktop notification library

    # === Terminal emulators ===
    kitty # Feature-rich GPU-based terminal emulator
    alacritty # GPU-accelerated terminal emulator

    # === File managers ===
    nemo # File manager

    # === Polkit ===
    polkit_gnome # GNOME's polkit agent

    # === XDG ===
    xdg-utils # Desktop integration helpers (xdg-open, etc.)
    xdg-desktop-portal # XDG desktop portal service
  ];
}
