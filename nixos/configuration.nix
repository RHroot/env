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
  boot.initrd.systemd.dbus.enable = true;
  boot.loader.systemd-boot.consoleMode = "1";

  networking = {
    hostName = env.hostname;
  };

  users.users.${env.username} = {
    isNormalUser = true;
    shell = pkgs.bash;
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
    font = "solar24x32";
    useXkbConfig = true;
  };

  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;

  services.libinput.enable = true;
  services.udisks2.enable = true;
  services.udev.extraRules = ''
    # Example: Mount USB drives to /media/<label> automatically
        ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect $devnode /media/%E{ID_FS_LABEL}"
    # Allow input group to access input devices
        KERNEL=="event*", NAME="input/%k", MODE="660", GROUP="input"
  '';

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  swapDevices = [
    {
      device = "/home/swapfile";
      size = 16384; # Size in MB(16Gb)
    }
  ];
  boot.kernel.sysctl."vm.swappiness" = 10;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
