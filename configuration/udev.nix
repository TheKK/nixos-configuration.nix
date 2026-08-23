{ config, pkgs, ... }:

{
  services.udev = {
    extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0711", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      ACTION=="add|change", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d027", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };

}
