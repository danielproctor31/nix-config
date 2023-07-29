{ config, pkgs, ... }:
{  
  nix = {
    package = pkgs.nix;

    # nix store optimisation
    settings.auto-optimise-store = true;
  };

  users.users.daniel.home = "/Users/daniel";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ 
    pkgs.vim
    pkgs.git
  ];

  homebrew = {
  enable = true;
  onActivation = {
    upgrade = true;
  };
  taps = [
    "homebrew/cask-fonts"
  ];
  brews = [
    "dotnet@6"
    "nvm"
    "pyenv"
  ];
  casks = [
    "font-caskaydia-cove-nerd-font"
    "docker"
    "firefox"
    "google-chrome"
    "iterm2"
    "visual-studio-code"
    "plexamp"
    "darktable"
    "cryptomator"
    "jetbrains-toolbox"
  ];
};
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;  # default shell

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
