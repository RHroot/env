{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vlc
    ffmpeg
    gimp
  ];
}
