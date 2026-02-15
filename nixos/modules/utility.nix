{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Zathura ===
    ps # PostScript interpreter and utilities
    zathura # Minimal PDF and document viewer
    poppler # PDF rendering backend used by viewers

    # === Utility ===
    brave # Privacy-focused web browser
    steam # Gaming platform and client
    evince # Document viewer for PDF and other formats
    appflowy # Open-source Notion-style productivity app
    librewolf # Privacy-focused web browser based on Firefox
    telegram-desktop # Telegram messaging desktop client
    libreoffice-fresh # Full-featured office suite (latest stable)
  ];
}
