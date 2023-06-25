{
  description = "My NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, ... }:
      let
          hm = home-manager.lib;
      in {
      # NixOS configuration
      nixosConfigurations."blade" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/blade/configuration.nix ];
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
