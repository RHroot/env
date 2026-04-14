{
  config,
  pkgs,
  lib,
  env,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Essential CLI Tools ===
    btop # Modern resource monitor (CPU, RAM, disk, network)
    wget # Non-interactive file downloader
    curl # Data transfer tool for URLs
    dust # Disk usage analyzer (du alternative)
    stow # Symlink-based dotfile manager
    tree # Display directory structure as a tree
    gnupg # Encryption and signing tool (GPG)
    gnumake # Build automation tool (make)
    busybox # Single binary providing common Unix utilities
    img2pdf # Convert images to PDF without re-encoding
    tealdeer # Fast implementation of tldr (simplified
    keychain # Manage SSH and GPG agent keys
    coreutils # GNU core command-line utilities
    moreutils # Additional Unix utilities not in coreutils
    fastfetch # System information fetch tool (neofetch alternative)

    # === Zip & Archive Tools ===
    zip # Create ZIP archives
    gzip # GNU compression utility
    p7zip # 7z archive support
    unzip # Extract ZIP archives

    # === System Utilities ===
    blueman # Bluetooth manager (GUI)
    brightnessctl # Control screen backlight and LEDs
    imagemagick # Image manipulation tools (convert, mogrify, etc.)

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
