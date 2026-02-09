{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inkscape # Vector graphics editor for creating and editing scalable graphics
    audacity # Free, open-source audio editor and recorder
    obs-studio # Open Broadcaster Software for video recording and live streaming
    kdePackages.kdenlive # Non-linear video editor for creating and editing videos
  ];
}
