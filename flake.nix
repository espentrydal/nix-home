{
  description = "My Nix world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-init.url = "github:nix-community/nix-init";
    rust-overlay.url = "github:oxalica/rust-overlay";
    riff.url = "github:DeterminateSystems/riff";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , home-manager
    , rust-overlay
    , riff
    , nix-init
    }:
    let
      # Constants
      stateVersion = "22.11";
      system = "x86_64-linux";
      username = "espen";
      homeDirectory = self.lib.getHomeDirectory username;

      # System-specific Nixpkgs
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          xdg = { configHome = homeDirectory; };
        };
        overlays = [
          (import rust-overlay)
          (self: super: {
            riff = riff.packages.${system}.riff;
            nix-init = nix-init.packages.${system}.default;
          })
        ] ++ (with self.overlays; [ go node rust ]);
      };

      # Helper functions
      run = pkg: "${pkgs.${pkg}}/bin/${pkg}";
      # Modules
      home = import ./home { inherit homeDirectory pkgs stateVersion system username; };

    in
      {
        defaultPackage.${system} = home-manager.defaultPackage.${system};

        homeConfigurations = {
          default = "${username}";

          "${username}" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [ home ];
          };
        };

        lib = import ./lib {
          inherit pkgs;
        };

        overlays = import ./overlays;

      }

      //

      flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: {
        nixosConfigurations =
          let
            modules = [
              ./nixos/configuration.nix
              ./nixos/hardware-configuration.nix
            ];
          in
            nixpkgs.lib.nixosSystem {
              inherit modules system;
            };
      });

}
