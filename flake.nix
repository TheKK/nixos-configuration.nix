{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    workaround.url = "github:NixOS/nixpkgs/edb5ff75f24e95e1ff2a05329e4c051de5eea4f2";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, workaround, nixos-hardware, home-manager }: {
    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations.kks-nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ({ ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              nixpkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
              nix-direnv = final.nixpkgs-unstable.nix-direnv.override { enableFlakes = true; };
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
          home-manager.users.kk = (import ./home/kk) {
            inherit self;
            nixpkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          };
        }
      ];
    };
  };
}
