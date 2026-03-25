{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    wrapperConfig = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
      MOZ_WEBRENDER = "1";
    };

    preferences = {
      # ───────── RENDERING ─────────
      "gfx.webrender.all" = true;
      "gfx.webrender.compositor" = true;
      "layers.acceleration.force-enabled" = true;

      # Wayland + Xorg compatible acceleration
      "media.ffmpeg.vaapi.enabled" = true;
      "media.hardware-video-decoding.force-enabled" = true;
      "widget.dmabuf.force-enabled" = true;

      # ───────── CPU / PROCESS CONTROL ─────────
      "dom.ipc.processCount" = 6; # adjust: cores - 2
      "dom.ipc.processPrelaunch.enabled" = true;

      # ───────── MEMORY / CACHE ─────────
      "browser.cache.disk.enable" = false;
      "browser.cache.memory.enable" = true;
      "browser.cache.memory.capacity" = 262144;

      "browser.tabs.unloadOnLowMemory" = true;
      "browser.sessionstore.interval" = 60000;

      # Garbage collection tuning
      "javascript.options.mem.gc_incremental" = true;
      "javascript.options.mem.gc_compacting" = true;

      # ───────── NETWORK ─────────
      "network.http.max-connections" = 1200;
      "network.http.max-persistent-connections-per-server" = 10;
      "network.http.pipelining" = false; # keep off (modern HTTP/2/3)

      # ───────── LATENCY / SMOOTHNESS ─────────
      "layout.frame_rate" = 0;
      "apz.frame_delay.enabled" = false;

      # ───────── UI / BACKGROUND REDUCTION ─────────
      "browser.newtabpage.enabled" = false;
      "browser.startup.page" = 0;

      "browser.pocket.enabled" = false;
      "extensions.pocket.enabled" = false;

      "browser.download.panel.shown" = true;

      # ───────── TELEMETRY HARD OFF ─────────
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.archive.enabled" = false;

      "datareporting.healthreport.uploadEnabled" = false;
    };

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";
      };
    };
  };
}
