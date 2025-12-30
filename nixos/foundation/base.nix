{
  config,
  pkgs,
  lib,
  env,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Essentials ===
    bc
    fd
    git
    bat
    btop
    htop
    wget
    curl
    dust
    stow
    tree
    gnupg
    delta
    xclip
    killall
    busybox
    keychain
    coreutils
    moreutils
    fastfetch
    # === Zip & Archive Tools ===
    zip
    gzip
    p7zip
    unzip
    # === System Utilities ===
    blueman
    brightnessctl
    # === For Fast Downloads ===
    aria2
  ];
  programs.command-not-found.enable = true;
  programs.nix-index = {
    enable = true;
    package = pkgs.nix-index;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
}
