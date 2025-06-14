{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
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
              nixpkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
            })
          ];
        })
        ./configuration.nix
        nixos-hardware.nixosModules.dell-xps-13-9343
        ./cachix.nix
        ./workaround-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.kk = (import ./home/kk) {
            inherit self;
          };
        }
      ];
    };
  };
}
