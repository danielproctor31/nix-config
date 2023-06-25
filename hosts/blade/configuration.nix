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
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-706ae0db-c6c4-45c5-86b1-886876219691".device = "/dev/disk/by-uuid/706ae0db-c6c4-45c5-86b1-886876219691";
  boot.initrd.luks.devices."luks-706ae0db-c6c4-45c5-86b1-886876219691".keyFile = "/crypto_keyfile.bin";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "blade"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daniel = {
    isNormalUser = true;
    description = "Daniel";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "games" "kvm" "libvirt" "docker" ];
    packages = with pkgs; [
      # Add any extra packages you want installed for this user
      vscode
      google-chrome
      lutris
      steam
      protonup-qt
      heroic
      discord
      cryptomator
      plexamp
      darktable
      openrgb
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zsh
    vim
    git
    wireguard-tools
    podman
    distrobox
    firefox
    libreoffice
    flatpak
    nvidia-offload
  ];

  programs.zsh.enable = true;

  # Enable flakes
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
  '';
  };

  # NVIDIA
  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
    ];

  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Fix graphical corruption on suspend/resume
    powerManagement.enable = true;
    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;
    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = true;
    # Enable the nvidia settings menu
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    
    prime = {
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
