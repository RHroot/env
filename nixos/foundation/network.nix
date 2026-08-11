{
  config,
  pkgs,
  lib,
  env,
  ...
}:
{
  networking = {
    domain = env.domain;
    nameservers = [ ];
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      dns = "systemd-resolved";
      insertNameservers = [ ];
      settings = {
        main = {
          dns = "systemd-resolved";
          rc-manager = "unmanaged";
        };
        connection = {
          "ipv4.ignore-auto-dns" = true;
          "ipv6.ignore-auto-dns" = true;
          "ipv4.dns" = "";
          "ipv6.dns" = "";
          "ipv4.dns-priority" = -999;
          "ipv6.dns-priority" = -999;
          "ipv4.dhcp-send-hostname" = false;
          "ipv6.dhcp-send-hostname" = false;
          "ipv4.never-default" = true;
          "ipv6.never-default" = true;
        };
      };
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "8.8.8.8#dns.google"
        "8.8.4.4#dns.google"
        "2001:4860:4860::8888#dns.google"
        "2001:4860:4860::8844#dns.google"
      ];
      FallbackDNS = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
        "2606:4700:4700::1001#cloudflare-dns.com"
      ];
      Domains = "~.";
      DNSSEC = "allow-downgrade";
      DNSOverTLS = "yes";
      LLMNR = "no";
      MulticastDNS = "no";
      ReadEtcHosts = "yes";
      Cache = "yes";
      DNSStubListener = "yes";
    };
  };
  networking.networkmanager.dispatcherScripts = [
    {
      type = "pre-up";
      source = pkgs.writeShellScript "clear-link-dns-pre" ''
        ${pkgs.systemd}/bin/resolvectl revert "$1" 2>/dev/null || true
        ${pkgs.systemd}/bin/resolvectl dns "$1" "" 2>/dev/null || true
        ${pkgs.systemd}/bin/resolvectl domain "$1" "" 2>/dev/null || true
      '';
    }
    {
      type = "basic";
      source = pkgs.writeShellScript "clear-link-dns-post" ''
        case "$2" in
          up|dhcp4-change|dhcp6-change|vpn-up|connectivity-change|hostname|ip-change|down)
            ${pkgs.systemd}/bin/resolvectl revert "$1" 2>/dev/null || true
            ${pkgs.systemd}/bin/resolvectl dns "$1" "" 2>/dev/null || true
            ${pkgs.systemd}/bin/resolvectl domain "$1" "" 2>/dev/null || true
            ;;
        esac
      '';
    }
  ];

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
    networkmanagerapplet # System tray applet for managing NetworkManager connections
    proton-vpn # Official ProtonVPN graphical client
  ];

  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
  '';
}
