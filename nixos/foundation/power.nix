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
        value = "60";
      })
      batteryNames))
    // (builtins.listToAttrs (map (b: {
        name = "STOP_CHARGE_THRESH_${b}";
        value = "80";
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

  # intel-undervolt config (active only if power.undervolt.enable is true)
  undervoltConfig = lib.mkIf config.power.undervolt.enable {
    environment.systemPackages = with pkgs; [intel-undervolt];

    # Write the config file
    environment.etc."intel-undervolt.conf".text = ''
      # CPU core undervolt (mV). Start conservative at -80mV.
      # If stable after a few days, go to -100mV or even -120mV.
      # If you get freezes/crashes, bring it back up by ~10mV.
      undervolt 0 'CPU' ${toString config.power.undervolt.cpuOffset}

      # CPU cache — should match CPU or be slightly less aggressive
      undervolt 1 'GPU' ${toString config.power.undervolt.gpuOffset}

      # CPU cache plane — keep same as CPU
      undervolt 2 'CPU Cache' ${toString config.power.undervolt.cacheOffset}

      # System agent — leave at 0, rarely helps and can cause instability
      undervolt 3 'System Agent' 0

      # Analog I/O — leave at 0
      undervolt 4 'Analog I/O' 0

      # Power limits (watts). Helps cap heat bursts during turbo boost.
      # PL1 = sustained power limit, PL2 = short burst limit
      # Check your CPU TDP and set PL1 slightly below, PL2 at TDP.
      # Example for a 28W TDP chip: PL1=20, PL2=28
      # Adjust these to your CPU's TDP.
      power package ${toString config.power.undervolt.pl1} ${toString config.power.undervolt.pl2}

      # Temperature target — lower = throttles earlier but stays cooler
      # 85°C is a reasonable target (down from default ~100°C)
      tjoffset ${toString config.power.undervolt.tjOffset}
    '';

    # The intel-undervolt service applies settings on boot
    # Apply undervolt on boot
    systemd.services.intel-undervolt = {
      description = "Apply intel-undervolt settings";
      wantedBy = ["multi-user.target"];
      after = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.intel-undervolt}/bin/intel-undervolt apply";
        RemainAfterExit = true;
      };
    };

    # Also apply on resume from suspend (values get reset on sleep)
    systemd.services.intel-undervolt-resume = {
      description = "Re-apply intel-undervolt after resume";
      after = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
      wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.intel-undervolt}/bin/intel-undervolt apply";
      };
    };
  };
in {
  options.power = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable TLP-based power management for laptop";
    };

    undervolt = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable intel-undervolt for CPU undervolting (Intel CPUs only)";
      };

      cpuOffset = lib.mkOption {
        type = lib.types.int;
        default = -80;
        description = ''
          CPU core undervolt in mV (negative value). Start at -80 and test
          stability. Safe range is usually -50 to -150 depending on your chip.
          Common values: -80 (safe), -100 (moderate), -120 (aggressive).
        '';
      };

      gpuOffset = lib.mkOption {
        type = lib.types.int;
        default = -50;
        description = "Integrated GPU undervolt in mV (negative value).";
      };

      cacheOffset = lib.mkOption {
        type = lib.types.int;
        default = -80;
        description = ''
          CPU cache undervolt in mV. Usually keep this the same as cpuOffset
          or slightly less aggressive.
        '';
      };

      pl1 = lib.mkOption {
        type = lib.types.int;
        default = 20;
        description = ''
          Sustained power limit (PL1) in watts. Set slightly below your CPU's
          TDP for sustained cooler operation. Check your CPU spec for TDP.
        '';
      };

      pl2 = lib.mkOption {
        type = lib.types.int;
        default = 28;
        description = ''
          Short burst power limit (PL2) in watts. Usually set to your CPU's TDP.
          Controls how hard the CPU can boost for short periods.
        '';
      };

      tjOffset = lib.mkOption {
        type = lib.types.int;
        default = -15;
        description = ''
          Temperature junction offset in °C (negative value). Lowers the
          throttle target. -15 means the CPU starts throttling at ~85°C
          instead of the default ~100°C, reducing fan noise and heat.
        '';
      };
    };
  };

  config = lib.mkMerge [
    batsignalConfig
    tlpConfig
    undervoltConfig
  ];
}
