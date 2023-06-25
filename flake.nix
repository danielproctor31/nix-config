{
  description = "My NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO darwin
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, darwin, ... }:
      let
          hm = home-manager.lib;
      in {
      # NixOS configuration
      nixosConfigurations."blade" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/blade/configuration.nix ];
      };
      # MacOS configuration
      darwinConfigurations."mac" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./hosts/mac/configuration.nix ];
      };

      # home manager configs
      homeConfigurations."linux" = hm.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        modules = [ 
          ./home.nix 
          {
            home = {
              username = "daniel";
              homeDirectory = "/home/daniel";
            };
          }
        ];
      };
      homeConfigurations."mac" = hm.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;

        modules = [ 
          ./home.nix 
          {
            home = {
              username = "daniel";
              homeDirectory = "/Users/daniel";
            };
          }
        ];
      };
    };
}
