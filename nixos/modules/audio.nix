{
  config,
  pkgs,
  ...
}: {
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
    wireplumber.enable = true;

    # PipeWire engine clock (locked to 512)
    extraConfig.pipewire."10-clock" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.min-quantum" = 512;
        "default.clock.max-quantum" = 512;
        "default.clock.quantum" = 512;
        "clock.power-of-two-quantum" = true;
      };
    };
  };

  # WirePlumber runtime enforcement
  services.pipewire.wireplumber.extraConfig."10-force-quantum" = {
    "wireplumber.settings" = {
      "clock.force-quantum" = 512;
    };
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
