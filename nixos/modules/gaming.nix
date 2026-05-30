{
  config,
  pkgs,
  ...
}
: {
  environment.systemPackages = with pkgs; [
    faudio # XAudio2 implementation for Wine
    lutris # A simple, efficient and really customizable game launcher
    mangohud # A FPS counter
    gamemode # Automatically switches to gamemode when a game is running
    cabextract # Required for winetricks to install some components
    winetricks # For installing Wine components
    protonup-qt # For installing Proton components
    wineWow64Packages.full # Full Wine package with all components
  ];

  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        OBS_VKCAPTURE = "1";
        RADV_TEX_ANISO = "16";
      };
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
