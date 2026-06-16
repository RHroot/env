{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vlc # Video player
    evince # PDF viewer
    zotero # Reference manager
    foliate # Book reader and downloader
    blanket # Different Sounds in Background
    telegram-desktop # Messenger
    libreoffice-fresh # Office suite
    (writeShellScriptBin "brave" ''
      exec ${pkgs.brave}/bin/brave \
        --disable-features=PrivacySandboxSettings4 \
        --disable-sync \
        --disable-background-networking \
        --disable-component-update \
        --disable-default-apps \
        --no-first-run \
        --force-dark-mode \
        "$@"
    '')
  ];

  # programs.localsend = {
  #   enable = true;
  #   package = pkgs.localsend;
  #   openFirewall = true;
  # };

  environment.etc."brave/policies/managed/policies.json" = {
    text = builtins.toJSON {
      # PRIVACY & TELEMETRY
      MetricsReportingEnabled = false;
      SafeBrowsingExtendedReportingEnabled = false;
      UrlKeyedAnonymizedDataCollectionEnabled = false;
      CloudReportingEnabled = false;
      BackgroundNetworkingEnabled = false;

      # DISABLE ALL BLOAT FEATURES
      BraveRewards = false;
      BraveWallet = false;
      BraveVPNDisabled = true;
      BraveAIChat = false;
      BraveNews = false;
      BraveShields = true; # Keep this! It's actually useful

      # DISABLE BUILT-IN SERVICES
      PasswordManager = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      TranslateEnabled = false;
      SpellCheckServiceEnabled = false;
      AlternateErrorPagesEnabled = false;
      SearchSuggestEnabled = false;

      # PERFORMANCE & RESOURCES
      BackgroundModeEnabled = false;
      ContinueRunningBackgroundAppsEnabled = false;
      NetworkPredictionOptions = 2; # Never preload
      HardwareAccelerationModeEnabled = false; # Test this
      Disable3DAPIs = true;

      # UI CLEANUP
      PromotionalTabsEnabled = false;
      ShowHomeButton = false;
      BookmarkBarEnabled = true;
      DefaultBrowserSettingEnabled = false;
      AutoUpdateEnabled = false;

      # NEW TAB PAGE
      NewTabPageHideDefaultTopSites = true;
      NewTabPageAllowedBackgroundTypes = 1;

      # PROTOCOL HANDLING
      RegisteredProtocolHandlers = [];
      ExternalProtocolDialogShowAlwaysOpenCheckbox = false;

      # MISC
      DownloadRestrictions = 0; # 0=No restrictions, 1=Malicious, 2=Potentially dangerous, 3=All
      UnsafelyTreatInsecureOriginAsSecure = false;
      CommandLineFlagSecurityWarningsEnabled = false;
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
