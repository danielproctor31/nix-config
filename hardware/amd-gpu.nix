# AMD GPU hardware acceleration configuration
# AMDGPU kernel driver, Vulkan, and video acceleration support
{ config, lib, pkgs, ... }:
{
  # AMD GPU kernel driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware = {
    # AMD GPU configuration with hardware acceleration
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # VA-API and VDPAU for hardware video acceleration
        mesa.drivers
        vaapiVdpau
        libvdpau-va-gl
        # Vulkan drivers
        amdvlk
        vulkan-validation-layers
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        mesa.drivers
        amdvlk
      ];
    };
  };
}
