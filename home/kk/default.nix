{ self, ... }:
{ config, pkgs, ... }:

let
  fileDir = "${self}/home/kk/files";

  packages = let
    fonts = with pkgs; [ hermit font-awesome ];
    haskellDev = with pkgs.nixpkgs-unstable; [ ghc cabal-install ];
    randomProgram = with pkgs; [
      libreoffice
      powertop
      nfs-utils
      dnsutils
      smartmontools
      kdenlive
      p7zip
      cpufrequtils
      iperf
      tmux
      cifs-utils
      openssl
      zip
      networkmanagerapplet
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
      htop
      pstree
      jq
      file
      steam-run
      brightnessctl
      curl
      emacs
      fd
      feh
      ffmpeg
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
    aliases = {
      st = "status";
    };
    extraConfig = {
      init = { defaultBranch = "main"; };
      core = {
        editor = "${pkgs.neovim}/bin/nvim";
      };
    };
    delta = { enable = true; };
  };
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = { PASSWORD_STORE_DIR = "$HOME/.password-store"; };
  };
  programs.mpv.enable = true;

  services.mako = {
    enable = true;
    defaultTimeout = 1500;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 150;
    pinentryFlavor = "qt";
  };

  services.syncthing = { enable = true; };

  # home.file = { ".gitconfig" = { source = "${fileDir}/.gitconfig"; }; };
}
