{
  config,
  pkgs,
  ...
}
: {
  environment.systemPackages = with pkgs; [
    lutris # A simple, efficient and really customizable game launcher
    mangohud # MangoHUD
    gamescope # A launcher that optimizes the gaming experience
    winetricks # A program for installing and managing wine
    protonup-qt # A program for installing and managing wine
  ];

  # programs.steam = {
  #   enable = true;
  #   package = pkgs.steam;
  # };
}
