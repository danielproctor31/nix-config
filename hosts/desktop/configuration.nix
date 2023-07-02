{ config, lib, pkgs, ... }:

{
  imports = [ 
    /etc/nixos/hardware-configuration.nix
    ../../common/default.nix
    ../../common/nvidia.nix
    ../../home.nix
  ];

  networking.hostName = "desktop"; # Define your hostname.

  system.stateVersion = "23.05";
}
