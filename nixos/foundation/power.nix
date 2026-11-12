{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    batsignal
    config.boot.kernelPackages.cpupower
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
      CPU_MIN_PERF_ON_AC = 20; # 20% of max cpu
      CPU_MIN_PERF_ON_BAT = 20; # 20% of max cpu
      CPU_MAX_PERF_ON_AC = 100; # CPU Max
      CPU_MAX_PERF_ON_BAT = 70; # 70% of max cpu

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT0 = 75;

      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
    };
  };
}
