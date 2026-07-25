{
  config,
  pkgs,
  env,
  lib,
  ...
}:
{
  imports = [
    # === Hardware-Configuration ===
    /etc/nixos/hardware-configuration.nix
    # === Core ===
    ./foundation
    # === Modules ===
    ./modules
    # === Window Manager ===
    ./hyprland
    # === Desktop Manager ===
    ./XFCE
  ];

  power.enable = true;
  services.getty.autologinUser = "sten";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "1";

  networking = {
    hostName = env.hostname;
  };

  users.users.${env.username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "do i need to give a description to myself";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "podman"
    ];
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
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
    dates = [ "weekly" ];
  };
  nix.settings.auto-optimise-store = true;

  console = {
    enable = true;
    useXkbConfig = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u32b.psf.gz";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  hardware.enableRedistributableFirmware = true;

  hardware.enableAllFirmware = true;

  hardware.firmware = with pkgs; [
    linux-firmware
  ];

  services.fwupd.enable = true;

  services.libinput = {
    enable = true;

    touchpad = {
      disableWhileTyping = true;
      tapping = true;
      naturalScrolling = false;

      clickMethod = "clickfinger"; # better multi-finger clicks
      scrollMethod = "twofinger"; # standard
      accelProfile = "flat"; # or "adaptive"
      accelSpeed = "0.4"; # range: -1 to 1

      middleEmulation = true; # 3-finger middle click
    };

    mouse = {
      accelProfile = "flat";
      accelSpeed = "0.0";
      middleEmulation = true;
    };
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096; # Size in MB(4Gb)
    }
  ];
  boot.kernel.sysctl."vm.swappiness" = 10;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
