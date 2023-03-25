{
  description = "Jedrzej's system config";
    
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, darwin, nixpkgs, unstable, home-manager, ... }@inputs:
  let
    inherit (darwin.lib) darwinSystem;

    overlay-unstable = final: prev: {
      unstable =  import unstable {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    };

    nixpkgsConfig = {
      config = { allowUnfree = true; };
      overlays = [ overlay-unstable ];
    };
  in {
    darwinConfigurations = rec {
      jrochala-MacBook-Pro = darwinSystem {
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
