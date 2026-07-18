{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    gimp # Advanced image editor (GNU Image Manipulation Program)
    audacity # Free, open-source audio editor and recorder
    obs-studio # Open Broadcaster Software for video recording and live streaming
    kdePackages.kdenlive # Non-linear video editor for creating and editing videos
  ];
}
