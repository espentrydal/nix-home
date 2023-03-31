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

  fonts = with pkgs; [
    cascadia-code
    emacs-all-the-icons-fonts
    fira-code
    iosevka-comfy.comfy
    iosevka
    jetbrains-mono
  ];

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
  ];

  network = with pkgs; [
    nethogs
#    tailscale
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
#    python310
  ]);

  shellTools = with pkgs; [
    comma
    feh
    fd
#    pass
    pdfgrep
    ripgrep
    tree
    treefmt
    wget
    zip unzip
    zstd
  ];


in
bin
++ local
++ buildTools
++ fonts
++ monitoring
++ misc
++ network
++ nixTools
++ pythonTools
++ shellTools
