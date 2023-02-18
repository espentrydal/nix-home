{ config, pkgs, ... }:

let
  python =  pkgs.python310.withPackages( p: with p; [
    black
    flake8
    ipython
    jupyter
    pipx
    python-lsp-server
    python-lsp-black
  ]);
  nixGL = (pkgs.callPackage "${builtins.fetchTarball {
    url = https://github.com/guibou/nixGL/archive/c917918ab9ebeee27b0dd657263d3f57ba6bb8ad.tar.gz;
    sha256 = "0rrxbgsv54p7cvhi24dc9yv5nphjmdj51pvy5awf07x3f1jica98";
  }}/nixGL.nix" {}).auto.nixGLDefault;
in

{
  programs.alacritty = {
    enable = true;
    package =
      pkgs.writeShellScriptBin "alacritty" ''
           #!/bin/sh

           ${nixGL}/bin/nixGL ${pkgs.alacritty}/bin/alacritty "$@"
        '';
  };

  home.packages = with pkgs; [
    # development
    #clang
    clojure babashka clojure-lsp leiningen
    cmake
    gcc
    gnumake
    go
    jdk languagetool
    libtool
    python

    # network
    avahi
    bmon
    git
    nethogs
    mosh
    tcptrack
    #unstable.tailscale
    wget

    # nix
    nix-prefetch-git

    # utilites
    bat
    cachix
    fd
    feh
    fzf
    gparted
    gnupg
    guardian-agent
    htop
    pandoc
    pass
    pciutils
    pdfgrep
    ripgrep
    sqlite
    tmux
    tree
    usbutils
    xclip
    xkcdpass
    zip unzip

    #libvirt virt-manager

    # Graphical applications
    brightnessctl
    evince
    firefox
    gnome3.gnome-tweaks gnome3.dconf-editor
    flameshot gnome.gnome-screenshot
    masterpdfeditor
    networkmanagerapplet
    signal-desktop
    transmission
    xfce.xfce4-power-manager
    xorg.xkbcomp
    xss-lock
    uget uget-integrator

    # unstable.calibre
    # unstable.spotify
    # unstable.vivaldi
    # unstable.vscode

    # Fonts
    iosevka-bin
    iosevka-comfy.comfy
    noto-fonts
    noto-fonts-emoji
    source-code-pro
  ];
}
