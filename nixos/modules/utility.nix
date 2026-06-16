{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vlc # Video player
    brave # Web browser
    evince # PDF viewer
    zotero # Reference manager
    foliate # Book reader and downloader
    blanket # Different Sounds in Background
    telegram-desktop # Messenger
    libreoffice-fresh # Office suite
  ];

  # programs.localsend = {
  #   enable = true;
  #   package = pkgs.localsend;
  #   openFirewall = true;
  # };

  environment.etc."brave/policies/managed/policies.json" = {
    text = builtins.toJSON {
      # Disable ALL bloat features
      BraveRewards = false; # No BAT/rewards
      BraveWallet = false; # No crypto wallet
      BraveVPNDisabled = true; # No VPN
      BraveAIChat = false; # No AI (Leo)
      BraveNews = false; # No news feed
      BraveShields = true; # Keep privacy shields

      # Disable telemetry and tracking
      MetricsReportingEnabled = false;
      SafeBrowsingExtendedReportingEnabled = false;
      UrlKeyedAnonymizedDataCollectionEnabled = false;
      CloudReportingEnabled = false;

      # Disable built-in features you don't need
      PasswordManager = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      TranslateEnabled = false;
      SpellCheckServiceEnabled = false;

      # Disable promotional content
      PromotionalTabsEnabled = false;
      ShowHomeButton = false; # Clean new tab page

      # Disable background processes
      BackgroundModeEnabled = false;
      ContinueRunningBackgroundAppsEnabled = false;

      # Reduce resource usage
      NetworkPredictionOptions = 2; # 0=Always, 1=Wifi only, 2=Never
      DefaultBrowserSettingEnabled = false;
      SearchSuggestEnabled = false;

      # Disable GPU acceleration (can cause issues, but helps performance on some systems)
      Disable3DAPIs = true;
      HardwareAccelerationModeEnabled = true; # Try this if you have GPU issues

      # Prevent automatic updates and background checking
      AutoUpdateEnabled = false;
      BackgroundNetworkingEnabled = false;
    };
    mode = "0644";
  };

  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox-bin;
  #   preferences = {
  #     # === Privacy & Performance ===
  #     "toolkit.telemetry.enabled" = false;
  #     "datareporting.healthreport.uploadEnabled" = false;
  #     "datareporting.policy.dataSubmissionEnabled" = false;
  #     "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
  #     "privacy.resistFingerprinting" = false;
  #     "privacy.trackingprotection.enabled" = true;
  #     "privacy.trackingprotection.cryptomining.enabled" = true;
  #     "privacy.trackingprotection.fingerprinting.enabled" = true;
  #     "browser.newtabpage.activity-stream.showSponsored" = false;
  #     "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  #     "browser.pocket.enabled" = false;
  #     "browser.tabs.crashReporting.sendReport" = false;
  #     "browser.sessionstore.interval" = 15000;
  #     "network.http.max-connections" = 256;
  #     # === Font Settings ===
  #     # Force serif as default font
  #     "font.default.x-western" = "serif";
  #     "font.default" = "serif";
  #     # === Native Vertical Tabs (Firefox 130+) ===
  #     "browser.tabs.verticalTabs.enabled" = true;
  #     # === Force Dark Theme ===
  #     "browser.theme.toolbar-theme" = 0;
  #     "browser.theme.content-theme" = 0;
  #     "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
  #     "ui.systemUsesDarkTheme" = 1;
  #     # === GTK/System Integration ===
  #     "widget.use-xdg-desktop-portal.file-picker" = 1;
  #     "widget.use-xdg-desktop-portal.mime-handler" = 1;
  #     "widget.use-xdg-desktop-portal.settings" = 1;
  #     # === Annoying Remember Password ===
  #     "signon.rememberSignons" = false;
  #   };
  # };

  xdg.mime.defaultApplications = {
    # # Text
    "text/html" = ["brave-browser.desktop"];
    # Web
    "x-scheme-handler/http" = ["brave-browser.desktop"];
    "x-scheme-handler/https" = ["brave-browser.desktop"];
    # PDF viewer
    "application/pdf" = ["org.gnome.Evince.desktop"];
    # Video
    "video/mp4" = ["vlc.desktop"];
    "video/x-matroska" = ["vlc.desktop"];
  };
}
