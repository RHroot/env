{
  config,
  pkgs,
  env,
  ...
}:
{
  networking = {
    domain = env.domain;
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = false;
      insertNameservers = [ ];
    };
  };

  services.resolved.enable = false;

  services.dnscrypt-proxy = {
    enable = true;
    upstreamDefaults = true;

    settings = {
      listen_addresses = [
        "127.0.0.1:53"
        "[::1]:53"
      ];

      server_names = [ ];

      # Privacy & Protocols
      doh_servers = true;
      ipv4_servers = true;
      ipv6_servers = true;
      require_nolog = true;
      require_dnssec = true;
      require_nofilter = true; # For Ad blocking and Malware blocking set this to false

      # Caching
      cache = true;
      cache_size = 4096;
    };
  };

  services.fail2ban.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [ ];
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
