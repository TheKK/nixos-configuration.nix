{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware }: {
    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations.kks-nixos = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
         ./_configuration.nix
         nixos-hardware.nixosModules.dell-xps-13-9343
         ./cachix.nix
       ];
     };
  };
}
