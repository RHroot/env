{
  config,
  pkgs,
  env,
  ...
}: {
  imports = [
    (import (fetchTarball "https://github.com/oxcl/nix-flake-helium-browser/archive/main.tar.gz")).nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    vlc # Video player
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

  programs.helium = {
    enable = true;
    flags = [
      "--ozone-platform-hint=auto"
    ];
    policies = {
      "BrowserSignin" = 0;
      "PasswordManagerEnabled" = false;
      "SyncDisabled" = true;
      "SpellcheckEnabled" = true;
    };
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
    "text/html" = ["helium.desktop"];
    # Web
    "x-scheme-handler/http" = ["helium.desktop"];
    "x-scheme-handler/https" = ["helium.desktop"];
    # PDF viewer
    "application/pdf" = ["org.gnome.Evince.desktop"];
    # Video
    "video/mp4" = ["vlc.desktop"];
    "video/x-matroska" = ["vlc.desktop"];
  };
}
