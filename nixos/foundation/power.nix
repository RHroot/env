{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = [ pkgs.batsignal ];
  systemd.user.services.batsignal = {
    description = "Battery monitor";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.batsignal}/bin/batsignal -w 30 -c 20 -d 10 -D 5 -b 'systemctl hibernate'";
      Restart = "on-failure";
    };
  };

  services.power-profiles-daemon.enable = true; # Dynamic power profiles
  services.thermald.enable = true; # Prevents thermal throttling (Intel only)

  powerManagement.powertop.enable = true; # Auto-tunes hardware power savings
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave"; # Default CPU governor

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
            echo 75 > "$bat/charge_control_start_threshold" 2>/dev/null || echo 75 > "$bat/charge_start_threshold" 2>/dev/null || true # Start at 75%
            echo 80 > "$bat/charge_control_end_threshold" 2>/dev/null || echo 80 > "$bat/charge_stop_threshold" 2>/dev/null || true # Stop at 80%
          fi
        done
      '';
    };
  };
}
