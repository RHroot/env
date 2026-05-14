{
  config,
  pkgs,
  ...
}
: {
  environment.systemPackages = with pkgs; [
    lutris # A simple, efficient and really customizable game launcher
    wineWowPackages.full # Full Wine package with all components
    winetricks # For installing Wine components
    protontricks # For installing Proton components
    protonup-qt # For installing Proton components
    mangohud # A FPS counter
    gamemode # Automatically switches to gamemode when a game is running
    dxvk # DirectX to Vulkan translation
    vkd3d # DirectX 12 to Vulkan translation
    cabextract # Required for winetricks to install some components
    faudio # XAudio2 implementation for Wine
  ];

  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  services.flatpak.enable = true;
  # programs.steam = {
  #   enable = true;
  #   package = pkgs.steam.override {
  #     extraEnv = {
  #       OBS_VKCAPTURE = "1";
  #       RADV_TEX_ANISO = "16";
  #     };
  #   };
  #   extraCompatPackages = with pkgs; [
  #     proton-ge-bin
  #   ];
  # };
}
