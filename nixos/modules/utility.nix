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
    librewolf # Privacy-focused web browser based on Firefox
    libreoffice-fresh # Full-featured office suite (latest stable)
  ];
}
