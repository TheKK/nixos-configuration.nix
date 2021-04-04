{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager }: {
    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations.kks-nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ({ ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              # We want version ^1.2.3 to cache inputs of nix flake.
              nix-direnv = nixpkgs-unstable.legacyPackages.${system}.nix-direnv;
            })
          ];
        })
        ./configuration.nix
        nixos-hardware.nixosModules.dell-xps-13-9343
        ./cachix.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.kk = (import ./home/kk) self;
        }
      ];
    };
  };
}
