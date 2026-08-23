{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      ...
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      # replace 'joes-desktop' with your hostname here.
      nixosConfigurations.kks-nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          (
            { ... }:
            {
              nixpkgs.overlays = [
                (final: prev: {
                  nixpkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    		  noctalia = inputs.noctalia.packages.${system}.default;
                })
		(import ./overlays/krita.nix)
              ];
            }
          )
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
      nixConfig = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
      };
    };
}
