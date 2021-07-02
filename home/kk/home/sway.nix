{ fileDir, ... }@homeAttrs:

{ config, pkgs, ... }:

let
in {
  imports = [ (import ./alacritty.nix homeAttrs) ];

  home.packages = with pkgs; [
    i3status
    swaylock
    swayidle
    wl-clipboard
    wdisplays
    mako
    wofi
  ];

  xdg.configFile = { "sway" = { source = "${fileDir}/sway"; }; };
}
