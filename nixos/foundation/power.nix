{
  config,
  pkgs,
  lib,
  ...
}: let
  batteryNames =
    builtins.filter (b: builtins.match "BAT[0-9]+" b != null)
    (builtins.attrNames
      ((builtins.tryEval (builtins.readDir "/sys/class/power_supply")).value or {}));

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

  batsignalConfig = {
    environment.systemPackages = with pkgs; [batsignal];
    systemd.user.services.batsignal = {
      description = "Battery monitor";
      wantedBy = ["default.target"];
      serviceConfig = {
        ExecStart = "${pkgs.batsignal}/bin/batsignal -w 30 -c 20 -d 10";
        Restart = "on-failure";
      };
    };
  };

  tlpConfig = lib.mkIf config.power.enable {
    environment.systemPackages = with pkgs; [tlp];

    services.tlp = {
      enable = true;
      settings =
        batterySettings
        // {
          # -------------------------
          # CPU PERFORMANCE (AC)
          # -------------------------
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_BOOST_ON_AC = 1;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_AC = 0;
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          # -------------------------
          # CPU PERFORMANCE (BAT)
          # -------------------------
          CPU_SCALING_GOVERNOR_ON_BAT = "performance";
          CPU_BOOST_ON_BAT = 1;
          CPU_MAX_PERF_ON_BAT = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";

          # -------------------------
          # USB + RUNTIME PM
          # -------------------------
          USB_AUTOSUSPEND = 0;
          RUNTIME_PM_ON_AC = "on";
          RUNTIME_PM_ON_BAT = "auto";

          # -------------------------
          # Intel P-State tuning
          # -------------------------
          CPU_HWP_DYN_BOOST = 1;

          RESTORE_THRESHOLDS_ON_BAT = 1;
        };
    };

    systemd.services."systemd-rfkill.service".enable = false;
    systemd.services."systemd-rfkill.socket".enable = false;
  };
in {
  options.power.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable high-performance power profile";
  };

  config = lib.mkMerge [
    batsignalConfig
    tlpConfig
  ];
}
