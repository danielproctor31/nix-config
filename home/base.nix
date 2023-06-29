{ config, pkgs, ... }:
{
  home.stateVersion = "23.05";

  home.packages = [
    pkgs.zsh
    pkgs.git
    pkgs.terraform
    pkgs.awscli2
    pkgs.vim
    pkgs.nano
    pkgs.direnv
    pkgs.nerdfonts
  ];

  imports = [
    ./programs/git/git.nix
    ./programs/zsh/zsh.nix
  ];

  programs.home-manager.enable = true;
}
