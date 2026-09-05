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

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.configurationLimit = 5;
  boot.loader.grub.gfxmodeEfi = "1600x1200,auto";
  # NOTE: When on Grub press 'c' and enter the console and then type 'videoinfo' to get all the modes available for your display and use whatever you like

  boot.loader.efi.canTouchEfiVariables = true;

  services.getty.autologinUser = env.username;

  networking = {
    hostName = env.hostname;
  };

  users.users.${env.username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = env.description;
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
  security.polkit.enable = true;
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "daily" ];
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

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

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

  services.gvfs.enable = true;
  services.fwupd.enable = true;
  services.udisks2.enable = true;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096; # Size in MB(4Gb)
    }
  ];
  boot.kernel.sysctl."vm.swappiness" = 10; # It tells the Linux kernel how aggressively to use your disk's swap space instead of physical RAM from 0 to 100

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
