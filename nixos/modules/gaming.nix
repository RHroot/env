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
    capSysNice = false; # Gamescope doesn't work if true
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  xdg.desktopEntries."steam" = {
    name = "Steam";
    exec = "steam -nofriendsui %U";
    icon = "steam";
    categories = [ "Game" ];
  };
}
