{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    steam
    evince
    calibre
    vesktop
    libreoffice-fresh
    (brave.override {
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--use-gl=angle"
        "--use-angle=gl"
        "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiIgnoreDriverChecks,Vulkan"
        "--disable-features=UseChromeOSDirectVideoDecoder"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--ignore-gpu-blocklist"
      ];
    })
  ];

  xdg.mime.defaultApplications = {
    # Browser
    "text/html" = ["brave-browser.desktop"];
    "x-scheme-handler/http" = ["brave-browser.desktop"];
    "x-scheme-handler/https" = ["brave-browser.desktop"];
    # PDF viewer
    "application/pdf" = ["org.gnome.Evince.desktop"];
    # Video
    "video/mp4" = ["vlc.desktop"];
    "video/x-matroska" = ["vlc.desktop"];
  };
}
