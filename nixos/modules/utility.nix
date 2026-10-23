{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mpv # Video player
    gimp # Advanced image editor (GNU Image Manipulation Program)
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

  programs.firefox = {
    enable = true;

    # Preferences (User defaults, can still be toggled in about:config)
    preferences = {
      # UI & Dark Theme
      "devtools.theme" = "dark";
      "ui.systemUsesDarkTheme" = 1;
      "browser.theme.dark-private-windows" = true;
      "layout.css.prefers-color-scheme.content-override" = 0;

      # Native Vertical Tabs (Requires Firefox 130+)
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;

      # RAM & Performance (Prevents Chromium-style bloat)
      "browser.cache.memory.capacity" = 512000; # 500MB memory cache
      "browser.sessionstore.interval" = 30000; # Write to disk less often
      "browser.sessionhistory.max_entries" = 10; # Limit back/forward history

      # Hardware Acceleration (Wayland)
      "media.ffmpeg.vaapi.enabled" = true;
      "gfx.webrender.all" = true;
      "widget.dmabuf.force-enabled" = true;

      # Remove Bloat
      "extensions.pocket.enabled" = false;
    };

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      Preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-types" = 1;
      };
    };
  };

  xdg.mime.defaultApplications = {
    # # Text
    "text/html" = [ "firefox.desktop" ];
    # Web
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    # Video
    "video/mp4" = [ "mpv.desktop" ];
    "video/x-matroska" = [ "mpv.desktop" ];
    # File manager
    "inode/directory" = [ "pcmanfm.desktop" ];
    # PDF viewer
    "application/pdf" = [ "org.gnome.Evince.desktop" ];
  };
}
