{ pkgs }:

{
  devops = with pkgs; [ flyctl packer terraform vagrant ];

  clojure =
    let
      javaVersion = 17;
      overlays = [
        (self: super: rec {
          jdk = super."jdk${toString javaVersion}";
          boot = super.boot.override {
            inherit jdk;
          };
          clojure = super.clojure.override {
            inherit jdk;
          };
          leiningen = super.leiningen.override {
            inherit jdk;
          };
        })
      ];
    in
      with pkgs; [ boot clojure leiningen ];

  go = with pkgs; [ go go2nix gotools ];

  kubernetes = with pkgs; [ kubectl kubectx kustomize minikube ];

  node = with pkgs; [ nodejs yarn ] ++ (with pkgs.nodePackages; [ pnpm ]);

  protobuf = with pkgs; [ buf protobuf ];

  python = with pkgs; [
    python311
    poetry
    virtualenv
  ]
  ++ (with pkgs.python311Packages; [
    pip
  ]);

  rust = with pkgs; [
    rustToolchain
    cargo-audit
    cargo-cross
    cargo-deny
    cargo-edit
    cargo-expand
    cargo-fuzz
    cargo-make
    cargo-outdated
    cargo-profiler
    openssl
    pkg-config
    rust-analyzer
  ];
}
