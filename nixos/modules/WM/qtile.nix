{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    windowManager.qtile = {
      enable = true;
    };
    displayManager.lightdm = {
      enable = true;
      extraSeatDefaults = ''
        display-setup-script = ${pkgs.writeScript "lightdm-display-setup" ''
          #!${pkgs.bash}/bin/bash
          ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 1920x1080 --rate 60
        ''}
      '';
    };
  };

  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
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
  services.displayManager.defaultSession = "qtile";

  xdg.portal = {
    enable = true;
    configPackages = [pkgs.xdg-desktop-portal-gtk];
  };

  xdg.mime.defaultApplications = {
    # Images
    "image/png" = ["feh.desktop"];
    "image/jpeg" = ["feh.desktop"];
    "image/webp" = ["feh.desktop"];
    "image/gif" = ["feh.desktop"];
    # File manager
    "inode/directory" = ["nemo.desktop"];
  };

  environment.systemPackages = with pkgs; [
    # === Qtile ===
    python313Packages.qtile # Qtile core
    python313Packages.qtile-extras # Qtile extras
    xorg.xorgserver # X server

    # === Basic ===
    feh # Image viewer
    nemo # File manager
    rofi # Menu system
    picom # X compositor
    xclip # Clipboard manager
    kitty # Feature-rich GPU-based terminal emulator
    dunst # Desktop notifications
    libinput # Input device management library
    playerctl # Media player control via MPRIS
    libnotify # Desktop notification library
    alacritty # GPU-accelerated terminal emulator

    # === Input and Gestures ===
    xdotool # X11 keyboard/mouse automation tool
    libinput-gestures # Gesture recognition and customization framework

    # === Polkit ===
    polkit_gnome # GNOME's polkit agent

    # === XDG ===
    xdg-utils # Desktop integration helpers (xdg-open, etc.)
    xdg-desktop-portal # XDG desktop portal service
  ];
}
