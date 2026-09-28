{
  config,
  pkgs,
  lib,
  ...
}:
let
  # i7-8850H: base ~2600000, turbo ~4300000
  minFreq = "800000";
  maxFreq = "3500000"; # 3.5 GHz cap, good balance
  epp = "balance_performance";
in
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
  powerManagement.cpuFreqGovernor = lib.mkForce "powersave";

  systemd.services.cpu-tuning = {
    description = "CPU min/max/EPP tuning";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      min_avail=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq)

      for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
        echo "$min_avail" > "$f" 2>/dev/null || true
      done

      for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
        echo ${maxFreq} > "$f" 2>/dev/null || true
      done

      for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
        echo ${minFreq} > "$f" 2>/dev/null || true
      done

      for e in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        echo ${epp} > "$e" 2>/dev/null || true
      done
    '';
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
