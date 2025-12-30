{
  config,
  pkgs,
  lib,
  ...
}: let
  batteryNames =
    builtins.filter (b: builtins.match "BAT[0-9]+" b != null)
    (builtins.attrNames ((builtins.tryEval (builtins.readDir "/sys/class/power_supply")).value or {}));
  batterySettings =
    (builtins.listToAttrs (map (b: {
        name = "START_CHARGE_THRESH_${b}";
        value = "80";
      })
      batteryNames))
    // (builtins.listToAttrs (map (b: {
        name = "STOP_CHARGE_THRESH_${b}";
        value = "95";
      })
      batteryNames));

  # Configuration block for batsignal (always active)
  batsignalConfig = {
    environment.systemPackages = with pkgs; [batsignal];
    systemd.user.services.batsignal = {
      description = "Batsignal battery monitor";
      wantedBy = ["default.target"];
      serviceConfig = {
        ExecStart = "${pkgs.batsignal}/bin/batsignal -w 30 -c 20 -d 10 -W 'Battery is getting low!' -C 'Battery critically low!'";
        Restart = "on-failure";
      };
    };
  };

  # Configuration block for TLP (active only if power.enable is true)
  tlpConfig = lib.mkIf config.power.enable {
    environment.systemPackages = with pkgs; [tlp];
    services.tlp = {
      enable = true;
      settings =
        batterySettings
        // {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MAX_PERF_ON_BAT = 80;
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          PLATFORM_PROFILE_ON_AC = "balanced";
          PLATFORM_PROFILE_ON_BAT = "low-power";
          USB_AUTOSUSPEND = 1;
          USB_EXCLUDE_BTUSB = 1;
          USB_EXCLUDE_AUDIO = 1;
          RUNTIME_PM_ON_AC = "auto";
          RUNTIME_PM_ON_BAT = "auto";
          RESTORE_THRESHOLDS_ON_BAT = 1;
        };
    };
    systemd.services."systemd-rfkill.service".enable = false;
    systemd.services."systemd-rfkill.socket".enable = false;
  };
in {
  # Define the option for the TLP profile
  options.power = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable TLP-based power management for laptop";
    };
  };

  # Merge the two independent configuration blocks
  config = lib.mkMerge [
    batsignalConfig
    tlpConfig
  ];
}
