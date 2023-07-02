{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/nvidia.nix
  ];

  networking.hostName = "desktop"; # Define your hostname.  

  system.stateVersion = "23.05";
}
