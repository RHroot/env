{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
    ./git.nix
    ./network.nix
    ./power.nix
    ./shell.nix
  ];
}
