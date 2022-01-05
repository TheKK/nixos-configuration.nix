{ config, pkgs, ... }:

{
  services.udev.packages = [ pkgs.libmtp.out ];
}
