{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = false;
    autoRepeatDelay = 200;
    autoRepeatInterval = 50;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.displayManager.ly.enable = false;
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
  };
  programs.hyprlock.enable = true;
  programs.waybar.enable = true;
  services.hypridle.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  # Enable polkit for GUI privilege prompts
  security.polkit.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
  };
  environment.systemPackages = with pkgs; [
    # === HYPRLAND ===
    hyprland
    hyprcursor
    hypridle
    hyprland-protocols
    hyprland-qt-support
    hyprland-qtutils
    hyprlock
    hyprpicker
    hyprshot
    wlroots_0_19
    # === basic ===
    libnotify
    dunst
    waybar
    swww
    wl-clipboard
    playerctl
    fuzzel
    # === Theming ===
    matugen
    wallust
    # === Terminal emulators ===
    alacritty
    kitty
    # === Zathura ===
    zathura
    poppler
    ps
    # === File managers ===
    nautilus
    # === Polkit ===
    kdePackages.polkit-kde-agent-1
    # === Utility ===
    telegram-desktop
    appflowy
    heroic
    libreoffice-fresh
  ];
}
