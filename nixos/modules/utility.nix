{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Utility ===
    brave # Privacy-focused web browser
    steam # Gaming platform and client
    evince # Document viewer for PDF and other formats
    libreoffice-fresh # Full-featured office suite (latest stable)
  ];
}
