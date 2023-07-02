{ config, lib, pkgs, ... }:
let
    nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports = [ 
    ./hardware-configuration.nix 
    ../../common/default.nix
    ../../common/nvidia.nix
  ];

  networking.hostName = "blade"; # Define your hostname.

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-706ae0db-c6c4-45c5-86b1-886876219691".device = "/dev/disk/by-uuid/706ae0db-c6c4-45c5-86b1-886876219691";
  boot.initrd.luks.devices."luks-706ae0db-c6c4-45c5-86b1-886876219691".keyFile = "/crypto_keyfile.bin"; 
  
  environment = {
    sessionVariables = {
      MOZ_USE_XINPUT2 = "1"; # enable touchscreen support in firefox
    };
    systemPackages = with pkgs; [
      polychromatic
    ];
  };

  hardware = {
    # openrazer
    openrazer.enable = true;
    openrazer.users = ["daniel"];
    
    # Nvidia prime
    nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:59:0:0";
    };
  };

  system.stateVersion = "23.05";
}
