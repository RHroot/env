{
  description = "Hybrid NixOS flake with stable base and selected unstable packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    helium-flake.url = "github:oxcl/nix-flake-helium-browser";
    helium-flake.inputs.nixpkgs.follows = "nixpkgs";

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
    helium-flake,
    ...
  }: let
    env = let
      username = "sten";
      hostname = "rhroot";
      domain = "local";
      fqdn = "${hostname}.${domain}";
    in {inherit username hostname domain fqdn;};
  in {
    nixosConfigurations.${env.hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit env helium-flake;};

      modules = [
        ./nixos/configuration.nix
        nix-index-database.nixosModules.nix-index

        ({
          pkgs,
          lib,
          helium-flake,
          ...
        }: {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";

          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit (prev.stdenv.hostPlatform) system;
                config.allowUnfree = true;
              };
            })
            helium-flake.overlays.default
          ];

          environment.systemPackages = with pkgs; [
            unstable.vim
            helium
          ];
        })
      ];
    };
  };
}
