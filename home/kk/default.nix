{ self, ... }:
{ config, pkgs, ... }:

let
  fileDir = "${self}/home/kk/files";

  packages = let
    fonts = with pkgs; [ hermit font-awesome-ttf font-awesome ];
    haskellDev = with pkgs; [ ghc cabal-install ghcid haskell-language-server ];
    randomProgram = with pkgs; [
      llvm_13
      nfs-utils
      dnsutils
      smartmontools
      kdenlive
      olive-editor
      p7zip
      cpufrequtils
      python
      iperf
      obs-studio
      go
      yarn
      nodejs
      tmux
      cifs-utils
      openssl
      zip
      gnome3.networkmanagerapplet
      openfortivpn
      zlib
      nmap
      usbutils
      asciinema
      gnupg
      binutils
      gcc
      gdb
      cgdb
      graphviz
      cachix
      notify-desktop
      neovim
      htop
      pstree
      jq
      file
      steam-run-native
      bat
      brightnessctl
      cowsay
      curl
      emacs
      fd
      feh
      ffmpeg
      fortune
      grim
      hdparm
      ncdu
      nm-tray
      pavucontrol
      ranger
      ripgrep
      slurp
      tig
      time
      tree
      wf-recorder
      wget
      xwayland
      tokei
    ];
    nixProgram = with pkgs; [ nixpkgs-fmt nix-tree nix-du ];
    networkPrograms = with pkgs; [ mtr ];
    archivePrograms = with pkgs; [ unzip unar ];
    graphicalPrograms = with pkgs; [ gimp ];
  in builtins.concatLists [
    fonts
    randomProgram
    nixProgram
    networkPrograms
    archivePrograms
    haskellDev
    graphicalPrograms
  ];

in {
  imports = let homeAttrs = { inherit fileDir; };
  in [ (import ./home/sway.nix homeAttrs) ];

  manual.html.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "kk";
  home.homeDirectory = "/home/kk";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  systemd.user.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };

  home.packages = packages;

  programs.pazi.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = { gst = "${pkgs.git}/bin/git status"; };
    prezto.enable = true;
    prezto.prompt.theme = "giddie";
    prezto.pmodules = let
      defs = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "prompt"
      ];
    in defs ++ [ "archive" "history-substring-search" ];
  };

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.git = {
    enable = true;
    userName = "Ying-Ruei Liang (TheKK)";
    userEmail = "thumbd03803@gmail.com";
    signing = {
      key = "97D5962071B77357B4E4C45DB37E75CC529BF418";
      signByDefault = true;
    };
    aliases = { st = "status"; };
    extraConfig = { init = { defaultBranch = "main"; }; };
    delta = { enable = true; };
  };
  programs.password-store = {
    enable = true;
    package = pkgs.pass-otp;
    settings = { PASSWORD_STORE_DIR = "$HOME/.password-store"; };
  };
  programs.mpv.enable = true;

  programs.mako = {
    enable = true;
    defaultTimeout = 2000;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 150;
    pinentryFlavor = "qt";
  };

  services.syncthing = { enable = true; };

  # home.file = { ".gitconfig" = { source = "${fileDir}/.gitconfig"; }; };
}
