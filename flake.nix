{
  description = "My NixOS Configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, ... }:
  let
    # Shared username across all systems
    username = "daniel";

    # Special args to pass to all modules
    specialArgs = { inherit username; };

    # Helper function for home-manager configuration
    mkHomeManagerConfig = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.users.${username} = import ./home.nix;
    };

    # System configurations
    systems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    # NixOS configurations
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit specialArgs;
        modules = [ 
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          mkHomeManagerConfig
        ];
      };
    };

    # Development shells
    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          nixpkgs-fmt
          nil # Nix LSP
          statix # Nix linter
          nix-tree # Visualize dependency tree
          nvd # Nix version diff tool
          deadnix # Find and remove dead code
        ];
        
        shellHook = ''
          echo "NixOS Configuration Development Environment"
          echo "Available tools: nixpkgs-fmt, nil, statix, nix-tree, nvd, deadnix"
        '';
      };
    });

    # Formatters for `nix fmt`
    formatter = forAllSystems (system: 
      nixpkgs.legacyPackages.${system}.nixpkgs-fmt
    );

  };
}
