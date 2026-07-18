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
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
        "2606:4700:4700::1001#cloudflare-dns.com"
        "1.1.1.2#cloudflare-dns.com"
        "1.0.0.2#cloudflare-dns.com"
        "2606:4700:4700::1112#cloudflare-dns.com"
        "2606:4700:4700::1002#cloudflare-dns.com"
      ];
      FallbackDNS = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
        "2620:fe::fe#dns.quad9.net"
        "2620:fe::9#dns.quad9.net"
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

  boot.kernelModules = [
    "tcp_bbr"
    "ipv6"
  ];
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = lib.mkOverride 500 "bbr";
    "net.core.default_qdisc" = lib.mkOverride 500 "fq";

    "net.ipv4.conf.all.accept_redirects" = lib.mkOverride 500 0;
    "net.ipv4.conf.default.accept_redirects" = lib.mkOverride 500 0;

    "net.ipv4.conf.all.send_redirects" = lib.mkOverride 500 0;
    "net.ipv4.conf.default.send_redirects" = lib.mkOverride 500 0;

    "net.ipv4.conf.all.rp_filter" = lib.mkOverride 500 1;
    "net.ipv4.conf.default.rp_filter" = lib.mkOverride 500 1;

    "net.ipv4.tcp_syncookies" = lib.mkOverride 500 1;

    "net.ipv4.tcp_fastopen" = lib.mkOverride 500 3;
    "net.core.netdev_max_backlog" = lib.mkOverride 500 16384;

    "net.ipv4.ip_forward" = lib.mkOverride 500 0;
  };
}
