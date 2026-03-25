{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    steam
    evince
    libreoffice-fresh
    brave
  ];

  environment.variables = {
    CHROMIUM_FLAGS = ''
      --enable-features=UseOzonePlatform,WaylandWindowDecorations,VaapiVideoDecoder
      --ozone-platform-hint=auto
      --ignore-gpu-blocklist
      --enable-gpu-rasterization
      --enable-zero-copy
      --enable-accelerated-video-decode
      --process-per-site
      --renderer-process-limit=6
      --enable-quic
      --smooth-scrolling
    '';
  };
}
