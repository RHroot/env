{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mangohud # A FPS counter
    gamemode # Automatically switches to gamemode when a game is running
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
      };
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
