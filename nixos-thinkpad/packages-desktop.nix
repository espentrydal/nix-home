{ config, pkgs, ... }:

let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      dvisvgm dvipng # for preview and export as html
      pdfx xmpincl fontawesome5 cmap fontspec academicons ragged2e
      xcolor tcolorbox enumitem environ dashrule ifmtarg multirow
      changepage biblatex roboto fontaxes lato paracol footmisc
      hanging wrapfig amsmath ulem hyperref capt-of;
  });

in {
  environment.systemPackages = with pkgs; [
    # editors
    neovim
    tex

    # development
    clang
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
    unstable.tailscale
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
    rpi-imager
    sqlite
    tmux
    tree
    usbutils
    xclip
    xkcdpass
    zip unzip

    #libvirt virt-manager

    # Graphical applications
    alacritty
    brightnessctl
    evince
    unstable.firefox
    gnome3.gnome-tweaks gnome3.dconf-editor
    flameshot gnome.gnome-screenshot
    libreoffice
    masterpdfeditor
    networkmanagerapplet
    signal-desktop
    transmission
    xfce.xfce4-power-manager
    xorg.xkbcomp
    xss-lock
    uget uget-integrator

    unstable.calibre
    unstable.spotify
    unstable.vivaldi
    unstable.vscode
    unstable.zotero
  ];

  #
  # Programs and services with config
  #
  services.tailscale.package = with pkgs; unstable.tailscale;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    #pinentryFlavor = "gnome3";
  };

  # programs.ssh = {
  #   startAgent = true;
  #   agentTimeout = "6h";
  #   askPassword = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
  # };

  programs.tmux = {
    enable = true;
    shortcut = "b";
    plugins = with pkgs.tmuxPlugins ; [
      continuum
      cpu
      net-speed
      nord
      sensible
      tmux-fzf
    ];
    newSession = true;
    extraConfig =
      ''
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'MunifTanjim/tmux-suspend'
      set -g @plugin 'MunifTanjim/tmux-mode-indicator'

      set -g @continuum-boot 'on'
      set -g status-right '%Y-%m-%d %H:%M #{tmux_mode_indicator}'

      # Initialize TMUX plugin manager (at the very bottom of tmux.conf)
      run '~/.tmux/plugins/tpm/tpm'
      '';
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  #
  # Docker
  #
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    autoPrune.enable = true;
    rootless.enable = true;
    rootless.setSocketVariable = true;
  };

}
