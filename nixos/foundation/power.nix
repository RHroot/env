{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.power.enable;
in
{
  options.power.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable power management profiles and battery thresholds";
  };

  config = lib.mkMerge [
    # 1. Core Battery Monitoring (Always Active)
    {
      environment.systemPackages = with pkgs; [ batsignal ];
      systemd.user.services.batsignal = {
        description = "Battery monitor";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.batsignal}/bin/batsignal -w 30 -c 20 -d 10";
          Restart = "on-failure";
        };
      };
    }

    # 2. Dynamic Profiles & Thresholds (Conditional on power.enable)
    (lib.mkIf cfg {
      # Enable the core power-profiles-daemon service
      services.power-profiles-daemon.enable = true;

      powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

      # Dynamic runtime configuration for battery thresholds (No hardcoding)
      systemd.services.battery-charge-thresholds = {
        description = "Dynamically set battery charge thresholds";
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "set-thresholds" ''
            for bat in /sys/class/power_supply/BAT*; do
              if [ -d "$bat" ]; then
                echo 80 > "$bat/charge_control_start_threshold" 2>/dev/null || echo 80 > "$bat/charge_start_threshold" 2>/dev/null || true
                echo 90 > "$bat/charge_control_end_threshold" 2>/dev/null || echo 90 > "$bat/charge_stop_threshold" 2>/dev/null || true
              fi
            done
          '';
        };
      };
    })
  ];
}
