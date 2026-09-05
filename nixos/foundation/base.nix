{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # === Essential CLI Tools ===
    jq # JSON processor
    btop # Modern resource monitor (CPU, RAM, disk, network)
    wget # Non-interactive file downloader
    curl # Data transfer tool for URLs
    dust # Disk usage analyzer (du alternative)
    stow # Symlink-based dotfile manager
    tree # Display directory structure as a tree
    file # Determine file type
    gnupg # Encryption and signing tool
    socat # Swiss army knife for data relay between anything
    ffmpeg # Multimedia framework for encoding, decoding, and processing media
    img2pdf # Convert images to PDF without re-encoding
    moreutils # Additional Unix utilities not in coreutils
    fastfetch # System information fetch tool
    lm_sensors # Read sensors data from Linux kernel

    # === Zip & Archive Tools ===
    gzip # GNU compression utility
    _7zz # 7z archive support
    unzip # Extract ZIP archives

    # === System Utilities ===
    blueman # Bluetooth manager (GUI)
    imagemagick # Image manipulation tools (convert, mogrify, etc.)
    brightnessctl # Control screen backlight and LEDs

    # === For Fast Downloads ===
    aria2 # Multi-source, resumable download manager
  ];
  programs.nix-ld.enable = true;
  xdg.mime = {
    enable = true;
  };
  programs.bat = {
    enable = true;
    package = pkgs.bat;
    extraPackages = with pkgs.bat-extras; [
      batman
    ];
  };
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
