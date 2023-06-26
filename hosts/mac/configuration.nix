{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ 
      pkgs.vim
      pkgs.git
    ];

  homebrew = {
  enable = true;
  onActivation = {
    upgrade = true;
  };
  # updates homebrew packages on activation,
  # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
  taps = [
    "homebrew/cask-fonts"
  ];
  brews = [
  
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
  ];
};
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  programs.zsh.enable = true;  # default shell

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}