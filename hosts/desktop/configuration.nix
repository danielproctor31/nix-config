{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/nvidia.nix
  ];

  networking.hostName = "desktop"; # Define your hostname.  
}
