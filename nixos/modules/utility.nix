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
    (pkgs.brave.override {
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform,CanvasOopRasterization,VaapiVideoDecoder"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--ignore-gpu-blocklist"
        "--enable-accelerated-video-decode"
        "--force-dark-mode"
        "--enable-features=WebUIDarkMode"
        "--gtk-version=4"
      ];
    })
  ];

  # Chromium/Brave policies (system-wide, enforced)
  environment.etc."chromium/policies/managed/brave.json".text = ''
    {
      "PasswordManagerEnabled": false,
      "AutofillAddressEnabled": false,
      "AutofillCreditCardEnabled": false,
      "BraveWalletDisabled": true,
      "BraveRewardsDisabled": true,
      "TorDisabled": true,
      "SyncDisabled": true,
      "MetricsReportingEnabled": false,
      "DefaultBrowserSettingEnabled": false,
      "HardwareAccelerationModeEnabled": true
    }
  '';
}
