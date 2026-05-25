{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gimp # Advanced image editor (GNU Image Manipulation Program)
    lmms # Digital audio workstation for music production
    krita # Professional digital painting and illustration software
    inkscape # Vector graphics editor for creating and editing scalable graphics
    audacity # Free, open-source audio editor and recorder
    obs-studio # Open Broadcaster Software for video recording and live streaming
    kdePackages.kdenlive # Non-linear video editor for creating and editing videos
  ];
}
