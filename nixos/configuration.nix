{
  config,
  pkgs,
  env,
  lib,
  ...
}: {
  imports = [
    # === Hardware-Configuration ===
    /etc/nixos/hardware-configuration.nix
    # === Core ===
    ./foundation
    #== Modules ===
    ./modules
  ];

  power.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "1";

  networking = {
    hostName = env.hostname;
  };

  users.users.${env.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "sten";
    extraGroups = ["networkmanager" "wheel" "input"];
  };

  security.rtkit.enable = true;
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 4d";
  };
  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };
  nix.settings.auto-optimise-store = true;

  console = {
    font = "latarcyrheb-sun32";
    useXkbConfig = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.enableRedistributableFirmware = true;

  services.libinput.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384; # Size in MB(16Gb)
    }
  ];
  boot.kernel.sysctl."vm.swappiness" = 10;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
