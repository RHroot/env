{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    batsignal
    linuxPackages.cpupower
  ];

  systemd.user.services.batsignal = {
    description = "Battery monitor";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.batsignal}/bin/batsignal -w 30 -c 20 -d 10 -D 5 -b 'systemctl suspend'";
      Restart = "on-failure";
    };
  };

  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      CPU_SCALING_MIN_FREQ_ON_AC = "800000";
      CPU_SCALING_MAX_FREQ_ON_AC = "3500000";

      CPU_SCALING_MIN_FREQ_ON_BAT = "800000";
      CPU_SCALING_MAX_FREQ_ON_BAT = "2600000";
    };
  };

  systemd.services.battery-charge-thresholds = {
    description = "Set battery charge thresholds";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "set-thresholds" ''
        for bat in /sys/class/power_supply/BAT*; do
          if [ -d "$bat" ]; then
            echo 75 > "$bat/charge_control_start_threshold" 2>/dev/null || echo 75 > "$bat/charge_start_threshold" 2>/dev/null || true
            echo 80 > "$bat/charge_control_end_threshold" 2>/dev/null || echo 80 > "$bat/charge_stop_threshold" 2>/dev/null || true
          fi
        done
      '';
    };
  };
}
