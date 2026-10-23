{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mpv # Video player
    gimp # Advanced image editor (GNU Image Manipulation Program)
    brave # Web browser
    evince # PDF viewer
    pcmanfm # File Manager
    calibre # Book reader and downloader
    obsidian # Knowledge Manager/Notes
    libinput # Input device management library
    audacity # Free, open-source audio editor and recorder
    libnotify # Desktop notification library
    obs-studio # Open Broadcaster Software for video recording and live streaming
    qbittorrent # Torrent client
    google-chrome # Secondary Browser for Exams and Stuff
    telegram-desktop # Messenger
    libreoffice-fresh # Office suite
    lxqt.lxqt-policykit # Polkit Agent
  ];

  environment.sessionVariables = {
    BROWSER = "brave";
  };
  environment.etc."xdg/pcmanfm/default/pcmanfm.conf".text = ''
    [ui]
    show_thumbnails=1
    thumbnail_max_size=52428800
  '';

  # programs.localsend = {
  #   enable = true;
  #   package = pkgs.localsend;
  #   openFirewall = true;
  # };

  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox;
  #
  #   autoConfig = ''
  #     // --- Privacy Overrides ---
  #     defaultPref("privacy.resistFingerprinting", false);
  #     defaultPref("signon.rememberSignons", false);
  #
  #     // --- UI & Dark Theme ---
  #     defaultPref("devtools.theme", "dark");
  #     defaultPref("ui.systemUsesDarkTheme", 1);
  #     defaultPref("browser.theme.dark-private-windows", true);
  #     defaultPref("layout.css.prefers-color-scheme.content-override", 0);
  #
  #     // --- Native Vertical Tabs ---
  #     defaultPref("sidebar.revamp", true);
  #     defaultPref("sidebar.verticalTabs", true);
  #     defaultPref("browser.tabs.verticalTabs.enabled", true);
  #
  #     // --- Cache & Memory Tuning ---
  #     defaultPref("browser.cache.disk.capacity", 512000);
  #     defaultPref("browser.cache.memory.capacity", 51200);
  #     defaultPref("browser.sessionstore.interval", 30000);
  #     defaultPref("browser.sessionhistory.max_entries", 10);
  #
  #     // --- Hardware Acceleration ---
  #     defaultPref("media.ffmpeg.vaapi.enabled", true);
  #     defaultPref("gfx.webrender.all", true);
  #     defaultPref("widget.use-aspect-ratio", true);
  #   '';
  # };

  xdg.mime.defaultApplications = {
    # # Text
    "text/html" = [ "brave-browser.desktop" ];
    # Web
    "x-scheme-handler/http" = [ "brave-browser.desktop" ];
    "x-scheme-handler/https" = [ "brave-browser.desktop" ];
    # Video
    "video/mp4" = [ "mpv.desktop" ];
    "video/x-matroska" = [ "mpv.desktop" ];
    # File manager
    "inode/directory" = [ "pcmanfm.desktop" ];
    # PDF viewer
    "application/pdf" = [ "org.gnome.Evince.desktop" ];
  };
}
