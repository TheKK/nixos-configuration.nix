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
      experimental-features = nix-command flakes
    '';

    binaryCaches =
      [ "https://nixcache.reflex-frp.org" "https://hydra.iohk.io" ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];

    maxJobs = 2;
    buildCores = 2;

    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "broadcom-sta" # Wifi firmware.
      "steam-runtime" # Steam and other games.
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;

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
      enabled = "fcitx";
      fcitx = { engines = with pkgs.fcitx-engines; [ rime ]; };
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
  services.xserver.desktopManager.gnome3.enable = true;

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

  users.defaultUserShell = pkgs.bash;

  users.users = {
    kk = {
      description = "The programer";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    firefox
    dash
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
    };
  };

  virtualisation.docker.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
  ];
}

