{
  config,
  pkgs,
  env,
  ...
}:
{
  networking = {
    domain = env.domain;
    nameservers = [ "1.1.1.1" ];
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      dns = "none";
      insertNameservers = [ ];
    };
  };

  services.resolved.enable = false;

  services.fail2ban.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [ 8000 ];
    allowedUDPPorts = [ ];
    checkReversePath = "loose";
    rejectPackets = true;
    logRefusedConnections = true;
  };

  environment.systemPackages = with pkgs; [
    proton-vpn # Official ProtonVPN graphical client
    networkmanagerapplet # System tray applet for managing NetworkManager connections
  ];

  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
  '';
}
