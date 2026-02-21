{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Utility ===
    steam # Gaming platform and client
    evince # Document viewer for PDF and other formats
    libreoffice-fresh # Full-featured office suite (latest stable)
  ];
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    languagePacks = ["en-US"];
    preferences = {
      ## Locale
      "intl.locale.requested" = "en-US";
      "spellchecker.dictionary" = "en-IN";
      ## Restore previous session
      "browser.startup.page" = 3;
      "browser.startup.homepage" = "about:blank";
      ## Force Firefox UI Dark Theme
      "browser.theme.content-theme" = 0; # 0 = dark
      "browser.theme.toolbar-theme" = 0; # 0 = dark
      ## Tell websites we prefer dark theme
      "layout.css.prefers-color-scheme.content-override" = 0;
      # 0 = dark, 1 = light, 2 = system, 3 = no override
      ## Force dark rendering for sites without dark mode
      "layout.css.force-color-scheme.enabled" = true;
      ## Always underline links
      "browser.underline_anchors" = true;
      ## Native vertical tabs
      "sidebar.revamp" = true;
      "sidebar.visibility" = "collapsed"; # forces sidebar open
      "sidebar.main.tools" = "tabs"; # selects tabs as the sidebar panel
      "sidebar.verticalTabs" = true; # enables vertical tab mode
      ## Privacy hardening
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "privacy.trackingprotection.fingerprinting.enabled" = true;
      "privacy.trackingprotection.cryptomining.enabled" = true;
      ## HTTPS only
      "dom.security.https_only_mode" = true;
      ## Disable WebRTC
      "media.peerconnection.enabled" = false;
      ## Fingerprint resistance
      "privacy.resistFingerprinting" = true;
      ## Disable speculative networking
      "network.prefetch-next" = false;
      "network.http.speculative-parallel-limit" = 0;
      ## Do not save passwords (sessions still persist)
      "signon.rememberSignons" = false;
      ## Enable legacy styling support
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFeedbackCommands = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };
  ## Native Wayland (Hyprland)
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
