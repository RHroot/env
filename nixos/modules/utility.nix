{
  config,
  pkgs,
  env,
  ...
}: {
  environment.systemPackages = with pkgs; [
    evince # PDF viewer
    libreoffice-fresh # Office suite
    steam # Gaming platform
    lutris # Game (Lutris)
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    preferences = {
      # Privacy & Performance
      "toolkit.telemetry.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.cryptomining.enabled" = true;
      "privacy.trackingprotection.fingerprinting.enabled" = true;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.pocket.enabled" = false;
      "browser.tabs.crashReporting.sendReport" = false;
      "browser.sessionstore.interval" = 15000;
      "network.http.max-connections" = 256;
      # Native Vertical Tabs (Firefox 130+)
      "browser.tabs.verticalTabs.enabled" = true;
      # Force Dark Theme
      "browser.theme.toolbar-theme" = 0;
      "browser.theme.content-theme" = 0;
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      "ui.systemUsesDarkTheme" = 1;
      # For the annoying remember password
      "signon.rememberSignons" = false;
    };
  };

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  xdg.mime.defaultApplications = {
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
    # PDF viewer
    "application/pdf" = ["org.gnome.Evince.desktop"];
    # Video
    "video/mp4" = ["vlc.desktop"];
    "video/x-matroska" = ["vlc.desktop"];
  };
}
