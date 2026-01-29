# Home Manager configuration
# User-level packages, programs, and dotfiles management
{ config, pkgs, lib, username, ... }:
{
  imports = [
    ./programs/git/git.nix
    ./programs/zsh/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };

  programs.home-manager.enable = true;
  
  # Enable direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Enable nix-index for command-not-found
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
  
  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.caskaydia-cove

    # Modern CLI replacements and essential tools
    btop              # Modern resource monitor (better than htop)
    eza               # Modern ls replacement
    bat               # Modern cat with syntax highlighting
    ripgrep           # Fast grep alternative
    fd                # Fast find alternative
    fzf               # Fuzzy finder
    jq                # JSON processor
    yq                # YAML processor
    delta             # Better git diffs
    tokei             # Code statistics
    dust              # Modern du
    duf               # Modern df
    procs             # Modern ps
    
    # Development tools
    nil               # Nix LSP for editor integration

    # User applications
    cryptomator
    vscode
  ];

  home.stateVersion = "24.11";
}
