{
  config,
  pkgs,
  env,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vlc # Video player
    evince # PDF viewer
    zotero # Reference manager
    foliate # Book reader and downloader
    blanket # Different Sounds in Background
    libreoffice-fresh # Office suite
    telegram-desktop # Messenger
  ];

  # programs.localsend = {
  #   enable = true;
  #   package = pkgs.localsend;
  #   openFirewall = true;
  # };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    preferences = {
      # === Privacy & Performance ===
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
      # === Font Settings ===
      # Force serif as default font
      "font.default.x-western" = "serif";
      "font.default" = "serif";
      # Specify exact font names
      "font.name.serif.x-western" = "Merriweather";
      "font.name.sans-serif.x-western" = "Inter";
      "font.name.monospace.x-western" = "JetBrainsMono Nerd Font";
      # Font sizes
      "font.minimum-size.x-western" = 0;
      "font.size.variable.x-western" = 16;
      "font.size.monospace.x-western" = 13;
      # Don't let websites override your font choices too aggressively
      "browser.display.use_document_fonts" = 1;
      # === Native Vertical Tabs (Firefox 130+) ===
      "browser.tabs.verticalTabs.enabled" = true;
      # === Force Dark Theme ===
      "browser.theme.toolbar-theme" = 0;
      "browser.theme.content-theme" = 0;
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      "ui.systemUsesDarkTheme" = 1;
      # === GTK/System Integration ===
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      "widget.use-xdg-desktop-portal.settings" = 1;
      # === Annoying Remember Password ===
      "signon.rememberSignons" = false;
    };
  };

  xdg.mime.defaultApplications = {
    # Text
    "text/html" = ["firefox"];
    # Web
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
    # PDF viewer
    "application/pdf" = ["org.gnome.Evince.desktop"];
    # Video
    "video/mp4" = ["vlc.desktop"];
    "video/x-matroska" = ["vlc.desktop"];
  };
}
