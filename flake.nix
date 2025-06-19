{
  description = "Jedrzej's system config";
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    pkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    nix-smithy-ls = {
      url = "github:ghostbuster91/nix-smithy-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, darwin, nixpkgs, unstable, home-manager, pkgs-unstable, nix-smithy-ls, ... }@inputs:
  let
    inherit (darwin.lib) darwinSystem;

    overlay-unstable = final: prev: {
      # smithy-lsp = smithy-lsp.packages.${prev.system}.default;
      unstable =  import unstable {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    };

    nixpkgsConfig = {
      config = { allowUnfree = true; };
      overlays = [
        overlay-unstable
      ];
    };
  in {
    darwinConfigurations = rec {
      vl-d-1182 = darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./configuration.nix
        ./homebrew.nix
        home-manager.darwinModules.home-manager {
          nixpkgs = nixpkgsConfig;
          /* nix.nixPath = { nixpkgs = "${inputs.nixpkgs-unstable}"; }; */
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jrochala = import ./home.nix;
          }
        ];
      };
    };
  };
}
