{
  description = "My NixOS Configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, darwin, ... }:
  {
    # NixOS configuration
    nixosConfigurations."desktop" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./hosts/desktop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          useGlobalPkgs = true;
          useUserPackages = true;
          home-manager.users.daniel = import ./home.nix;
        }
      ];
    };
    nixosConfigurations."blade" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./hosts/blade/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.daniel = import ./home.nix;
        }
      ];
    };

    # Darwin configuration
    darwinConfigurations."darwin" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [ 
        ./hosts/darwin/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.daniel = import ./home.nix;
        }
      ];
    };

    # home manager config (For non NixOS use)
    homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home/linux.nix ];
    };

    # home manager config for dawrin
    homeConfigurations."darwin" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [ ./home/darwin.nix ];
    };
  };
}
