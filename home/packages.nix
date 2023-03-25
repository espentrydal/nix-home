{ homeDirectory
, pkgs
}:

let
  bin = import ./bin.nix {
    inherit homeDirectory pkgs;
  };

  local = import ./local.nix {
    inherit pkgs;
  };

  buildTools = with pkgs; [
    cmake
  ];

  databaseTools = with pkgs; [ postgresql_15 ];

  devOpsTools = with pkgs; [
    dive
    doppler
  ];

  fonts = with pkgs; [
    cascadia-code
    emacs-all-the-icons-fonts
    fira-code
    iosevka-comfy.comfy
    iosevka
    jetbrains-mono
  ];

  gitTools = with pkgs.gitAndTools;
    [ diff-so-fancy git-codeowners gitflow ]
    ++ (with pkgs; [
      difftastic
      git-annex
      git-crypt
    ]);

  kubernetesTools = with pkgs; [
    kubectx
    kubectl
    minikube
  ];

  jsTools = (with pkgs; [
    nodejs-18_x # for global npm and npx
    deno
  ]) ++ (with pkgs.nodePackages; [
    pnpm
    yarn
  ]);

  monitoring = with pkgs; [
    bmon
    bottom
    btop
    htop
    pciutils
    usbutils
  ];

  # I'll categorize these later :)
  misc = with pkgs; [
    hugo # for initializing projects
    just
    keybase
    libiconv
    ncurses
    neofetch
    openssl
    pikchr
    pkg-config
#    podman
    qemu
  ];

  network = with pkgs; [
    nethogs
    tailscale
    tcptrack
  ];

  nixTools = with pkgs; [
    cachix
    nixfmt
    nixpkgs-fmt
    nix-init
    nix-prefetch-git
  ];

  pythonTools = with pkgs; [
    python311
    poetry
  ] ++ (with pkgs.python311Packages; [
    #httpie
    pip
    virtualenv
  ]);

  rustTools = with pkgs; [
    riff # from overlay
    rustup # for things like `cargo init`
  ];

  shellTools = with pkgs; [
    comma
    coreutils
    findutils
    feh
    fd
    pass
    pdfgrep
    ripgrep
    tree
    treefmt
    wget
    zip unzip
    zstd
  ];



  broken = with pkgs; [
    materialize   #  broken on aarch64-darwin but I hope to add them someday
    reattach-to-user-namespace # for tmux # only for darwin
  ];

in
bin
++ local
++ buildTools
#++ databaseTools
#++ devOpsTools
++ fonts
++ gitTools
#++ kubernetesTools
++ jsTools
++ monitoring
++ misc
++ network
++ nixTools
++ pythonTools
++ rustTools
++ shellTools
