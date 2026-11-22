{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Media
    mpv
    gimp
    audacity
    obs-studio

    # Documents and research
    evince
    zotero
    libreoffice
    stirling-pdf-desktop

    # File management
    thunar

    # Communication
    thunderbird-bin
    telegram-desktop
    whatsapp-electron

    # Productivity and learning
    anki-bin
    joplin-desktop

    # Utilities
    libnotify
    qbittorrent
    ffmpegthumbnailer
    lxqt.lxqt-policykit

    # Browser
    google-chrome
    (ungoogled-chromium.override {
      commandLineArgs = lib.concatStringsSep " " [
        "--force-dark-mode"
        "--enable-zero-copy"
        "--disable-features=MediaRouter"
        "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiVideoDecodeLinuxGL"
      ];
    })
  ];

  services.tumbler.enable = true;

  environment.sessionVariables = {
    BROWSER = "chromium";
  };

  # programs.localsend = {
  #   enable = true;
  #   package = pkgs.localsend;
  #   openFirewall = true;
  # };

  programs.chromium = {
    enable = true;
    extraOpts = {
      # UI / dark / search
      ShowHomeButton = true;
      WebContentsForceDark = true; # prefers-color-scheme.content-override = 0
      HomepageIsNewTabPage = false;
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "DuckDuckGo";
      HomepageLocation = "https://duckduckgo.com";
      NewTabPageLocation = "https://duckduckgo.com";
      DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";

      # RAM / perf / session
      RestoreOnStartup = 1;
      MemorySaverModeSavings = 2;
      HighEfficiencyModeEnabled = true; # native tab freezing, no Auto Tab Discard needed

      # Privacy / no phone-home
      BrowserSignin = 0;
      SyncDisabled = true;
      TranslateEnabled = false;
      SearchSuggestEnabled = false;
      NetworkPredictionOptions = 2;
      BlockThirdPartyCookies = true;
      DefaultGeolocationSetting = 2; # block location
      MetricsReportingEnabled = false;
      AlternateErrorPagesEnabled = false;
      UrlKeyedAnonymizedDataCollectionEnabled = false;

      # Bloat / passwords
      BackgroundModeEnabled = false;
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      ComponentUpdatesEnabled = false;
      AutofillCreditCardEnabled = false;
    };
  };

  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox-bin;
  #
  #   # Preferences (User defaults, can still be toggled in about:config)
  #   preferences = {
  #     # UI & Dark Theme
  #     "devtools.theme" = "dark";
  #     "ui.systemUsesDarkTheme" = 1;
  #     "browser.theme.dark-private-windows" = true;
  #     "layout.css.prefers-color-scheme.content-override" = 0;
  #
  #     # Native Vertical Tabs (Requires Firefox 130+)
  #     "sidebar.revamp" = true;
  #     "sidebar.verticalTabs" = true;
  #
  #     # RAM & Performance (Prevents Chromium-style bloat)
  #     "browser.sessionstore.interval" = 30000; # Write to disk less often
  #     "browser.cache.memory.capacity" = 512000; # 500MB memory cache
  #     "browser.sessionhistory.max_entries" = 10; # Limit back/forward history
  #
  #     # Hardware Acceleration & Streaming Buffers
  #     "gfx.webrender.all" = true;
  #     "media.ffmpeg.vaapi.enabled" = true;
  #     "widget.dmabuf.force-enabled" = true;
  #
  #     # Buffer & Decoding Fixes
  #     "media.av1.enabled" = false; # Forces fallback to hardware-accelerated VP9/H.264
  #     "media.cache_readahead_limit" = 120; # Increases pre-buffered window limit
  #     "media.cache_resume_threshold" = 30;
  #
  #     # Remove Bloat
  #     "extensions.pocket.enabled" = false;
  #   };
  #
  #   policies = {
  #     DisableTelemetry = true;
  #     OfferToSaveLogins = false;
  #     DisableFirefoxStudies = true;
  #     PasswordManagerEnabled = false;
  #     EnableTrackingProtection = {
  #       Value = true;
  #       Cryptomining = true;
  #       Fingerprinting = true;
  #     };
  #     Preferences = {
  #       "widget.use-xdg-desktop-portal.mime-types" = 1;
  #       "widget.use-xdg-desktop-portal.file-picker" = 1;
  #     };
  #   };
  # };

  xdg.mime.defaultApplications = {
    # # Text
    "text/html" = [ "chromium-browser.desktop" ];
    # Web
    "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
    "x-scheme-handler/https" = [ "chromium-browser.desktop" ];
    # Video
    "video/mp4" = [ "mpv.desktop" ];
    "video/x-matroska" = [ "mpv.desktop" ];
    # File manager
    "inode/directory" = [ "thunar.desktop" ];
    # PDF viewer
    "application/pdf" = [ "org.gnome.Evince.desktop" ];
  };
}
