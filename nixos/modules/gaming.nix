{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    heroic # Games Launcher
    mangohud # A FPS counter
  ];

  programs.gamemode = {
    enable = true;
    settings.general = {
      desiredgov = "performance";
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = false; # Gamescope doesn't work on wayland if true
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
