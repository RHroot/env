{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    displayManager.lightdm.enable = false;
  };

  services.displayManager.gdm.enable = false;
  services.displayManager.sddm.enable = false;

  services.getty.autologinUser = "sten";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "sten";
      };
    };
  };

  services.displayManager.defaultSession = "Hyprland";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    WAYLAND_DISPLAY = "wayland-0";
    XDG_CURRENT_DESKTOP = "Hyprland";
    NIXOS_OZONE_WL = "1";
  };

  environment.variables = {
    CHROMIUM_FLAGS = ''
      --enable-features=UseOzonePlatform,WaylandWindowDecorations,VaapiVideoDecoder
      --ozone-platform-hint=auto
      --ignore-gpu-blocklist
      --enable-gpu-rasterization
      --enable-zero-copy
      --enable-accelerated-video-decode
      --process-per-site
      --renderer-process-limit=6
      --enable-quic
      --smooth-scrolling
    '';
  };

  programs.hyprlock.enable = true;
  programs.waybar.enable = true;
  services.hypridle.enable = true;

  # Enable polkit for GUI privilege prompts
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  xdg.mime.defaultApplications = {
    # Images
    "image/png" = ["imv.desktop"];
    "image/jpeg" = ["imv.desktop"];
    "image/webp" = ["imv.desktop"];
    "image/gif" = ["imv.desktop"];
    # File manager
    "inode/directory" = ["org.gnome.Nautilus.desktop"];
  };

  environment.systemPackages = with pkgs; [
    # === HYPRLAND ===
    hyprland # Wayland compositor for dynamic tiling (Hyprland)
    hypridle # Idle management daemon for Hyprland
    hyprlock # Screen locker for Hyprland
    hyprshot # Screenshot utility for Hyprland
    hyprpicker # Color picker for Wayland/Hyprland
    hyprcursor # Cursor theme support for Hyprland
    hyprland-protocols # Wayland protocol extensions used by Hyprland
    hyprland-qt-support # Qt integration support for Hyprland
    hyprland-qtutils # Qt utilities for Hyprland components

    # === basic ===
    swww # Wayland wallpaper daemon with transitions
    dunst # Lightweight notification daemon
    waybar # Status bar for Wayland compositors
    fuzzel # Wayland-native application launcher (rofi alternative)
    playerctl # Media player control via MPRIS
    libnotify # Desktop notification library
    wl-clipboard # Clipboard utilities for Wayland
    wtype # Wayland tool to simulate keyboard input
    imv # Image viewer for Wayland

    # === Theming ===
    matugen # Generate color schemes from images
    wallust # Dynamic color generation based on wallpapers

    # === Terminal emulators ===
    kitty # Feature-rich GPU-based terminal emulator
    alacritty # GPU-accelerated terminal emulator

    # === File managers ===
    nautilus # GNOME file manager

    # === Polkit ===
    kdePackages.polkit-kde-agent-1 # PolicyKit authentication agent for Wayland

    # === XDG ===
    xdg-utils # Desktop integration helpers (xdg-open, etc.)
    xdg-desktop-portal # XDG desktop portal service
    xdg-desktop-portal-hyprland # XDG portal backend for Hyprland
  ];
}
