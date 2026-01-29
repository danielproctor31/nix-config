# Core NixOS configuration shared across all systems
# Platform-agnostic settings for Nix itself, users, and essential packages
{ config, lib, pkgs, nixpkgs, username, ... }:
{
  imports = [
    ../overlays/default.nix
  ];
  
  nix = {
    settings = {
      # Enable flakes and new nix command
      experimental-features = [ "nix-command" "flakes" ];
      
      # Nix store optimization
      auto-optimise-store = true;
      
      # Keep build dependencies for faster rebuilds
      keep-outputs = true;
      keep-derivations = true;
      
      # Build performance
      max-jobs = lib.mkDefault "auto";
      cores = lib.mkDefault 0;  # Use all available cores per build
      
      # Evaluation performance
      warn-dirty = false;
      
      # Security - restrict trusted users to avoid sandbox bypass
      allowed-users = [ "@wheel" ];
      trusted-users = [ "root" username ];
      sandbox = true;
      
      # Performance and reliability
      http-connections = 128;
      download-attempts = 5;
      
      # Better error messages
      show-trace = true;
    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
      persistent = true;  # Don't skip if system was off
    };

    # Use the same nixpkgs as the system flake
    registry.nixpkgs.flake = nixpkgs;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # Set your time zone
  time.timeZone = "Europe/London";

  # Select internationalisation properties
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      ++ lib.optional config.virtualisation.docker.enable "docker"
      ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd";
  };

  # List packages installed in system profile
  # Note: git is here for system-level operations and initial setup,
  # but user-specific git config is managed via home-manager
  environment.systemPackages = with pkgs; [
    neovim
    nano
    git
  ];

  # Enable SSH for remote management
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # ZSH shell - configuration in home-manager
  programs.zsh.enable = true;
}
