{ fileDir, nixpkgs-unstable, ... }@homeAttrs:

{ config, pkgs, ... }:

let
in {
  programs.alacritty.enable = true;
  programs.alacritty.package = nixpkgs-unstable.alacritty;
  home.packages = with pkgs; [ hermit ];
  xdg.configFile = {
    "alacritty/alacritty.yml" = { source = "${fileDir}/.alacritty.yml"; };
  };
}
