# Linux-specific NixOS configuration
# Desktop environment, graphics, sound, and Linux-only services
{ config, lib, pkgs, username, ... }:
{
  # Boot loader configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable RealtimeKit for audio
  security.rtkit.enable = true;

  services = {
    # Enable KDE Plasma 6 with Wayland
    desktopManager.plasma6.enable = true;
    
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "plasma";
    };
   
    # Enable sound with pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable CUPS for printing
    printing.enable = true;

    # Enable flatpak
    flatpak.enable = true;
  };

  # AMD GPU kernel driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    steam-hardware.enable = true;
    
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

  # Linux-specific system packages
  environment.systemPackages = with pkgs; [
    distrobox
    
    # KDE Applications
    kdePackages.kate
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.spectacle
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.kcalc
    kdePackages.filelight
    
    # KDE Integration
    kdePackages.kio-admin
    kdePackages.kio-extras
    kdePackages.kdeplasma-addons
    kdePackages.kdeconnect-kde
    
    # Virtualization GUI
    virt-manager
  ];

  programs.dconf.enable = true;

  # Virtualization
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;

    # Configure firewall
    firewall = {
      enable = true;
      # If packets are still dropped, they will show up in dmesg
      logReversePathDrops = true;
      
      # Common ports you might need
      allowedTCPPorts = [ 
        # 22    # SSH (if needed)
        # 80    # HTTP
        # 443   # HTTPS
      ];
      allowedUDPPorts = [ 
        # 51820 # WireGuard
      ];
      
      # WireGuard configuration - https://nixos.wiki/wiki/WireGuard
      # Uncomment if using WireGuard
      # WireGuard trips rpfilter up
      # extraCommands = ''
      #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      # '';
      # extraStopCommands = ''
      #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      # '';
    };
  };
}
