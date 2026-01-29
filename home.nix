# Home Manager configuration
# User-level packages, programs, and dotfiles management
{ config, pkgs, lib, username, stateVersion, ... }:
{
  imports = [
    ./programs/git/git.nix
    ./programs/zsh/zsh.nix
    ./programs/ssh/ssh.nix
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

  # Enable fzf for fuzzy finding
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  
  # System monitoring with btop
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
      truecolor = true;
      vim_keys = true;
      rounded_corners = true;
      update_ms = 1000;
    };
  };
  
  # Terminal multiplexer
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";
    extraConfig = ''
      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1
      
      # Better split commands
      bind | split-window -h
      bind - split-window -v
    '';
  };
  
  # Example: Manage dotfiles with home.file
  home.file = {
    # Example configuration file
    # ".config/some-app/config.toml".text = ''
    #   # Configuration contents
    # '';
    
    # Keep directory structure
    ".local/share/applications/.keep".text = "";
  };
  
  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })

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

  # WARNING: Do not change this value after initial installation!
  # This can be independent from system.stateVersion
  # https://nix-community.github.io/home-manager/index.xhtml#sec-usage-configuration
  home.stateVersion = "24.11";
  
  # Disable command-not-found since we use nix-index
  programs.command-not-found.enable = false;
}
