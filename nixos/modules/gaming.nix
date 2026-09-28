{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    heroic # Games Launcher
    mangohud # A FPS counter
    gamemode # Automatically switches to gamemode when a game is running
  ];

  programs.gamemode = {
    enable = true;
    settings.general = {
      desiredgov = "performance";
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = false; # Gamescope doesn't work if true
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
