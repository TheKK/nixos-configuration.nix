{ fileDir, ... }@homeAttrs:

{ config, pkgs, ... }:

let
in {
  programs.alacritty.enable = true;
  home.packages = with pkgs; [ hermit ];
  xdg.configFile = {
    "alacritty/alacritty.toml" = { source = "${fileDir}/alacritty.toml"; };
  };
}
