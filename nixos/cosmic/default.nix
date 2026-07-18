{
  config,
  pkgs,
  lib,
  ...
}:
{
  # === Cosmic ===
  services.desktopManager.cosmic.enable = true;
  services.displayManager.defaultSession = lib.mkForce "cosmic";

  environment.systemPackages = with pkgs; [
    google-chrome # Web browser
  ];
}
