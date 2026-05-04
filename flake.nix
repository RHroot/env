{
  description = "Hybrid NixOS flake with stable base and selected unstable packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nix-index-database,
    ...
  }: let
    system = "x86_64-linux";
    env = let
      username = "sten";
      hostname = "rhroot";
      domain = "local";
      fqdn = "${hostname}.${domain}";
    in {inherit username hostname domain fqdn;};
  in {
    nixosConfigurations.${env.hostname} = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {inherit env;};

      modules = [
        ./nixos/configuration.nix
        nix-index-database.nixosModules.nix-index

        ({pkgs, ...}: {
          nixpkgs.config.allowUnfree = true;

          nixpkgs.overlays = [
            (final: prev: {
              unstable = nixpkgs-unstable.legacyPackages.${system};
            })
          ];

          environment.systemPackages = with pkgs; [
            unstable.vim-full
          ];
        })
      ];
    };
  };
}
