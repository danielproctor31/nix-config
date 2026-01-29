# Desktop workstation configuration
# High-performance AMD GPU workstation with KDE Plasma
{ config, lib, pkgs, ... }:

{
  imports = [
    ../../common/core.nix
    ../../common/linux.nix
    ../../hardware/amd-gpu.nix
  ] ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

  networking.hostName = "desktop"; # Define your hostname.

  # Virtualization for desktop workstation
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  # WARNING: Do not change this value after initial installation!
  # It defines the first version of NixOS installed and is used to
  # maintain compatibility with application data created on older versions.
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
