# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  hardware.bluetooth.powerOnBoot = false;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      experimental-features = nix-command flakes
    '';

    settings = {
      max-jobs = 2;
      cores = 2;
      substituters = [
        "https://nixcache.reflex-frp.org"
      ];
      trusted-public-keys = [
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      ];
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "broadcom-bt-firmware" # Bluetooth firmware.
      "broadcom-sta" # Wifi firmware.
      "steam-runtime" # Steam and other games.
      "steam-original"
      "steam-run"
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot = {
    # TODO Workaround to apply modprobe config to hid-apple since it's inside
    # initrd. Without kernelModules, following options have no effect.
    kernelModules = [ "hid-apple" ];
    extraModprobeConfig = ''
      options hid_apple fnmode=0
    '';
  };

  hardware.firmware = with pkgs; [
    broadcom-bt-firmware
  ];

  boot.tmp.cleanOnBoot = true;

  # We don't need to wait online.
  systemd.services.NetworkManager-wait-online.enable = false;

  networking.hostName = "kks-nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Asia/Taipei";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "zh_TW.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
	libsForQt5.fcitx5-qt
	fcitx5-rime
      ];
    };
  };

  console = {
    earlySetup = true;
    font = "ter-i32b";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  # Enable the GNOME 3 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager = {
    gdm.enable = true;
    hiddenUsers = [ ];
  };
  services.xserver.desktopManager.gnome.enable = true;

  # services.gvfs.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable graphical stuff
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ intel-media-driver ];
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  xdg = {
    # portal.enable = true;
    # portal.gtkUsePortal = false;
    portal.extraPortals = with pkgs; [
      # xdg-desktop-portal-wlr
    ];
  };

  users.defaultUserShell = pkgs.bash;

  users.users = {
    kk = {
      description = "The programer";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    firefox
    vulkan-tools
    vulkan-loader
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  programs = {
    # We need to enable shell here so that when user using them it will sourcing required files.
    zsh.enable = true;

    vim.defaultEditor = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraPackages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        mako # notification daemon
        alacritty # Alacritty is the default terminal in the config
        dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      ];
      extraSessionCommands = ''
        fcitx5 -d
        export INPUT_METHOD=fcitx
        export QT_IM_MODULE=fcitx
        export GTK_IM_MODULE=fcitx
        export XMODIFIERS=@im=fcitx
        export XIM_SERVERS=fcitx
      '';
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
}

