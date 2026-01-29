# Desktop workstation configuration
# High-performance AMD GPU workstation with KDE Plasma
{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ../../common/core.nix
    ../../common/linux.nix
  ];

  networking.hostName = "desktop"; # Define your hostname.  

  system.stateVersion = "24.11";
}
