# Core NixOS configuration shared across all systems
# Platform-agnostic settings for Nix itself, users, and essential packages
{ config, lib, pkgs, username, ... }:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    
    settings = {
      # Nix store optimization
      auto-optimise-store = true;
      
      # Build performance
      max-jobs = lib.mkDefault "auto";
      cores = lib.mkDefault 0;  # Use all available cores per build
      
      # Evaluation performance
      warn-dirty = false;
      
      # Security
      allowed-users = [ "@wheel" ];
      trusted-users = [ "root" "@wheel" ];
      sandbox = true;
    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
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
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    nano
    git
  ];

  # ZSH shell - configuration in home-manager
  programs.zsh.enable = true;
}
