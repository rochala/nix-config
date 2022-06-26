{
  description = "Jedrzej's system config";
    
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

    nixpkgsConfig = {
      config = { allowUnfree = true; };
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
          nix.nixPath = { nixpkgs = "${inputs.nixpkgs-unstable}"; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jrochala = import ./home.nix;
          }
        ];
      };
    };
    
  };

  
  
}
