{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vlc # Versatile media player supporting most audio and video formats
    ffmpeg # Multimedia framework for encoding, decoding, and processing media
    gimp # Advanced image editor (GNU Image Manipulation Program)
  ];
}
