{
  config,
  pkgs,
  lib,
  env,
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
    # === Xsessions ===
    ./xsession
    # === Window Manager ===
    ./niri
  ];

  # === Hardware ===
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelParams = [
    "nowatchdog" # Disables hardware watchdog (saves CPU interrupts)
    "pcie_aspm=off" # Prevents PCIe bus timeout on wake
    "nvidia-drm.fbdev=1" # Enables NVIDIA framebuffer console
    "nvidia-drm.modeset=1" # Enables NVIDIA DRM KMS (required for modern Wayland)
    "nvme_core.default_ps_max_latency_us=0" # Prevents NVMe sleep hangs
  ];
  swapDevices = [
    {
      device = "/swapfile";
      size = 4096; # Size in MB(4Gb)
    }
  ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 60; # It tells the Linux kernel how aggressively to use your disk's swap space instead of physical RAM from 0 to 100
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.configurationLimit = 5;
  boot.loader.grub.gfxmodeEfi = "1600x1200,auto";
  # NOTE: When on Grub press 'c' and enter the console and then type 'videoinfo' to get all the modes available for your display and use whatever you like

  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = env.hostname;
  };

  users.users.${env.username} = {
    isNormalUser = true;
    description = env.description;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      # "podman"
      "gamemode"
    ];
    # subUidRanges = [
    #   {
    #     startUid = 100000;
    #     count = 65536;
    #   }
    # ];
    # subGidRanges = [
    #   {
    #     startGid = 100000;
    #     count = 65536;
    #   }
    # ];
  };

  services.gvfs.enable = true;
  services.fwupd.enable = true;
  services.udisks2.enable = true;
  services.openssh.enable = false;
  # services.getty.autologinUser = env.username;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        keepEnv = true;
        persist = true;
      }
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "daily" ];
  };
  nix.settings.auto-optimise-store = true;

  console = {
    enable = true;
    useXkbConfig = true;
  };

  systemd.services.console-font-double = {
    description = "Double console font with setfont -d";
    wantedBy = [ "multi-user.target" ];
    after = [
      "systemd-vconsole-setup.service"
      "console-setup.service"
    ];
    before = [ "getty.target" ];
    serviceConfig.Type = "oneshot";
    path = [ pkgs.kbd ];
    script = ''
      font=${pkgs.terminus_font}/share/consolefonts/ter-v32b.psf.gz
      for tty in /dev/tty1 /dev/tty2 /dev/tty3 /dev/tty4 /dev/tty5 /dev/tty6; do
        setfont -C "$tty" -d "$font" || true
      done
    '';
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

      accelSpeed = "0.4"; # range: -1 to 1
      accelProfile = "flat"; # or "adaptive"
      scrollMethod = "twofinger"; # standard
      clickMethod = "clickfinger"; # better multi-finger clicks

      middleEmulation = true; # 3-finger middle click
    };

    mouse = {
      accelProfile = "flat";
      accelSpeed = "0.0";
      middleEmulation = true;
    };
  };

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
