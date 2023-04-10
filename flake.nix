{
  description = "My Nix world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    nixos-hardware.url = "github:espentrydal/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-init.url = "github:nix-community/nix-init";
  };

  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , flake-utils
    , home-manager
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
          (self: super: {
            nix-init = nix-init.packages.${system}.default;
          })
        ];
      };
      x1-extreme = import "${nixos-hardware}/lenovo/thinkpad/x1-extreme/gen1";


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

        nixosConfigurations = {
          thinkpad-nixos = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              x1-extreme
              ./nixos-thinkpad/configuration.nix
              ./nixos-thinkpad/hardware-configuration.nix

              home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.espen = home;
              }
            ];
          };
        };
      };
}
