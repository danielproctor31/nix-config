{ config, lib, pkgs, ... }:
{
  # Enable flakes
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
  '';
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

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

  # enable flatpak
  services.flatpak.enable = true;

  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daniel = {
    isNormalUser = true;
    description = "Daniel";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "games" "kvm" "libvirtd" "docker" ];
    packages = with pkgs; [
      # Add any extra packages you want installed for this user
      vscode
      google-chrome
      lutris
      steam
      mangohud
      protonup-qt
      heroic
      discord
      cryptomator
      plexamp
      darktable
      jetbrains-toolbox
      dotnet-sdk
      virt-manager
      krita
      calibre
      unityhub
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
    distrobox
    firefox
    libreoffice
  ];

  programs.zsh.enable = true;

  virtualisation ={
    docker.enable = true;
    podman.enable = true;
    libvirtd.enable = true;
  };
  
  programs.dconf.enable = true; # needed for virt-manager. https://nixos.wiki/wiki/virt-manager
}
