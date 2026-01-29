{
  description = "My NixOS Configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, pre-commit-hooks, ... }:
  let
    # Shared username across all systems
    username = "daniel";

    # State version - change only when explicitly upgrading
    stateVersion = "24.11";

    # Special args to pass to all modules
    specialArgs = { inherit username stateVersion; };

    # Helper function for home-manager configuration with optional per-host overrides
    mkHomeManagerConfig = homeConfig: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.users.${username} = homeConfig;
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
        specialArgs = specialArgs // { inherit nixpkgs; };
        modules = [ 
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          (mkHomeManagerConfig (import ./home.nix))
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
          nix-diff # Compare derivations
          deadnix # Find and remove dead code
        ];
        
        shellHook = ''
          echo "NixOS Configuration Development Environment"
          echo "Available tools: nixpkgs-fmt, nil, statix, nix-tree, nvd, nix-diff, deadnix"
        '';
      };
    });

    # Formatters for `nix fmt`
    formatter = forAllSystems (system: 
      nixpkgs.legacyPackages.${system}.nixpkgs-fmt
    );

    # Pre-commit hooks for code quality
    checks = forAllSystems (system: {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixpkgs-fmt.enable = true;
          statix.enable = true;
          deadnix.enable = true;
        };
      };
    });

  };
}
