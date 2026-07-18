{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vlc # Video player
    evince # PDF viewer
    zotero # Reference manager
    foliate # Book reader and downloader
    blanket # Different Sounds in Background
    qbittorrent # Torrent client
    telegram-desktop # Messenger
    libreoffice-fresh # Office suite
  ];

  # programs.localsend = {
  #   enable = true;
  #   package = pkgs.localsend;
  #   openFirewall = true;
  # };

  # environment.etc."brave/policies/managed/policies.json" = {
  #   text = builtins.toJSON {
  #     # Disable ALL bloat features
  #     BraveRewards = false; # No BAT/rewards
  #     BraveWallet = false; # No crypto wallet
  #     BraveVPNDisabled = true; # No VPN
  #     BraveAIChat = false; # No AI (Leo)
  #     BraveNews = false; # No news feed
  #     BraveShields = true; # Keep privacy shields
  #
  #     # Disable telemetry and tracking
  #     MetricsReportingEnabled = false;
  #     SafeBrowsingExtendedReportingEnabled = false;
  #     UrlKeyedAnonymizedDataCollectionEnabled = false;
  #     CloudReportingEnabled = false;
  #
  #     # Disable built-in features you don't need
  #     PasswordManager = false;
  #     AutofillAddressEnabled = false;
  #     AutofillCreditCardEnabled = false;
  #     TranslateEnabled = false;
  #     SpellCheckServiceEnabled = false;
  #
  #     # Disable promotional content
  #     PromotionalTabsEnabled = false;
  #     ShowHomeButton = false; # Clean new tab page
  #
  #     # Disable background processes
  #     BackgroundModeEnabled = false;
  #     ContinueRunningBackgroundAppsEnabled = false;
  #
  #     # Reduce resource usage
  #     NetworkPredictionOptions = 2; # 0=Always, 1=Wifi only, 2=Never
  #     DefaultBrowserSettingEnabled = false;
  #     SearchSuggestEnabled = false;
  #
  #     # Disable GPU acceleration (can cause issues, but helps performance on some systems)
  #     Disable3DAPIs = true;
  #     HardwareAccelerationModeEnabled = true; # Try this if you have GPU issues
  #
  #     # Prevent automatic updates and background checking
  #     AutoUpdateEnabled = false;
  #     BackgroundNetworkingEnabled = false;
  #   };
  #   mode = "0644";
  # };

  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.librewolf;
  #
  #   autoConfig = ''
  #     defaultPref("privacy.resistFingerprinting", false);
  #     defaultPref("network.http.pipelining", true);
  #     defaultPref("network.http.max-connections", 256);
  #     defaultPref("browser.sessionstore.interval", 30000);
  #     defaultPref("network.http.pipelining.maxrequests", 8);
  #     defaultPref("devtools.theme", "dark");
  #     defaultPref("ui.systemUsesDarkTheme", 1);
  #     defaultPref("signon.rememberSignons", false);
  #     defaultPref("browser.tabs.verticalTabs.enabled", true);
  #     defaultPref("sidebar.verticalTabs", true);
  #     defaultPref("browser.theme.dark-private-windows", true);
  #     defaultPref("layout.css.prefers-color-scheme.content-override", 2);
  #     defaultPref("browser.cache.disk.capacity", 512000);
  #     defaultPref("browser.cache.memory.capacity", 51200);
  #     defaultPref("browser.tabs.remote.autostart.2", true);
  #     defaultPref("browser.sessionhistory.max_entries", 10);
  #   '';
  # };

  xdg.mime.defaultApplications = {
    # # Text
    "text/html" = [ "helium.desktop" ];
    # Web
    "x-scheme-handler/http" = [ "helium.desktop" ];
    "x-scheme-handler/https" = [ "helium.desktop" ];
    # PDF viewer
    "application/pdf" = [ "org.gnome.Evince.desktop" ];
    # Video
    "video/mp4" = [ "vlc.desktop" ];
    "video/x-matroska" = [ "vlc.desktop" ];
  };
}
