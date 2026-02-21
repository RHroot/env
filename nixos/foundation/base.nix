{
  config,
  pkgs,
  lib,
  env,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Essential CLI Tools ===
    bc # Arbitrary precision command-line calculator
    fd # Fast and user-friendly alternative to find
    git # Distributed version control system
    bat # cat replacement with syntax highlighting
    btop # Modern resource monitor (CPU, RAM, disk, network)
    htop # Interactive process viewer
    wget # Non-interactive file downloader
    curl # Data transfer tool for URLs
    dust # Disk usage analyzer (du alternative)
    stow # Symlink-based dotfile manager
    tree # Display directory structure as a tree
    wtype # Wayland tool to simulate keyboard input
    gnupg # Encryption and signing tool (GPG)
    delta # Syntax-highlighted git diff pager
    xclip # X11 clipboard access from the terminal
    killall # Kill processes by name
    busybox # Single binary providing common Unix utilities
    img2pdf # Convert images to PDF without re-encoding
    keychain # Manage SSH and GPG agent keys
    coreutils # GNU core command-line utilities
    moreutils # Additional Unix utilities not in coreutils
    fastfetch # System information fetch tool (neofetch alternative)
    gnumake # Build automation tool (make)

    # === Zip & Archive Tools ===
    zip # Create ZIP archives
    gzip # GNU compression utility
    p7zip # 7z archive support
    unzip # Extract ZIP archives

    # === System Utilities ===
    imv # Image viewer for Wayland
    blueman # Bluetooth manager (GUI)
    brightnessctl # Control screen backlight and LEDs

    # === For Fast Downloads ===
    aria2 # Multi-source, resumable download manager
  ];
  programs.command-not-found.enable = true;
  programs.nix-index = {
    enable = true;
    package = pkgs.nix-index;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      openssl
      zlib
      glib
    ];
  };
  xdg.mime = {
    enable = true;

    defaultApplications = {
      # Browser
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      # PDF
      "application/pdf" = ["org.gnome.Evince.desktop"];
      # Images
      "image/png" = ["imv.desktop"];
      "image/jpeg" = ["imv.desktop"];
      "image/webp" = ["imv.desktop"];
      "image/gif" = ["imv.desktop"];
      # Video
      "video/mp4" = ["vlc.desktop"];
      "video/x-matroska" = ["vlc.desktop"];
      # File manager
      "inode/directory" = ["org.gnome.Nautilus.desktop"];
    };
  };
}
