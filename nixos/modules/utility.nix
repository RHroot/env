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
    zotero # Reference manager
    calibre # Book reader and downloader
    blanket # Different Sounds in Background
    inkscape # Vector graphics editor
    audacity # Free, open-source audio editor and recorder
    megatools # MEGA tools to do big tasks faster through terminal
    mkvtoolnix # MKV tool to create and edit Matroska files
    obs-studio # Open Broadcaster Software for video recording and live streaming
    qbittorrent # Torrent client
    polkit_gnome # GUI Polkit agent
    telegram-desktop # Messenger
    libreoffice-fresh # Office suite
    kdePackages.kdenlive # Non-linear video editor for creating and editing videos
  ];

  # programs.localsend = {
  #   enable = true;
  #   package = pkgs.localsend;
  #   openFirewall = true;
  # };

  environment.etc."brave/policies/managed/policies.json" = {
    text = builtins.toJSON {
      # Corrected Brave-specific debloat features
      BraveRewardsDisabled = true;
      BraveWalletDisabled = true;
      BraveVPNDisabled = true;
      BraveAIChatEnabled = false;
      BraveNewsDisabled = true;

      # Additional Brave-specific bloat & telemetry to disable
      TorDisabled = true;
      BraveTalkDisabled = "Disabled"; # Note: Requires string "Disabled"
      BraveP3AEnabled = "Disabled"; # Privacy-preserving analytics
      BraveStatsPingEnabled = false;
      BraveWebDiscoveryEnabled = false;
      BraveSpeedreaderEnabled = false;
      BraveWaybackMachineEnabled = false;
      BravePlaylistEnabled = false;

      # Corrected Chromium standard features
      MetricsReportingEnabled = false;
      SafeBrowsingExtendedReportingEnabled = false;
      CloudReportingEnabled = false;

      PasswordManagerEnabled = false; # Changed from PasswordManager
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      TranslateEnabled = false;
      SpellcheckEnabled = false; # Disables local spellcheck
      SpellCheckServiceEnabled = false; # Disables cloud spellcheck
      PromotionalTabsEnabled = false;
      ShowHomeButton = false;

      # Background & Resource usage
      BackgroundModeEnabled = false;
      DefaultBrowserSettingEnabled = false;
      SearchSuggestEnabled = false;
      Disable3DAPIs = true;
      HardwareAccelerationModeEnabled = true;

      # Some More
      SyncDisabled = true;
      ClearBrowsingDataOnExitList = [
        "download_history"
        "cached_images_and_files"
      ];

      # Disable auto-updates
      AutoUpdateEnabled = false;
    };
    mode = "0644";
  };

  # programs.firefox = {
  #   enable = true;
  #   # package = pkgs.librewolf;
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
    # PDF viewer
    "application/pdf" = [ "org.gnome.Evince.desktop" ];
    # Video
    "video/mp4" = [ "mpv.desktop" ];
    "video/x-matroska" = [ "mpv.desktop" ];
  };
}
