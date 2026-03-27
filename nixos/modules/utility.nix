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
