{ config, lib, pkgs, ... }:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
  '';
    # nix store optimisation
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # boot loader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure console keymap
  console.keyMap = "uk";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
      extraLocaleSettings = {
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
    # fcitx - used for japanese input (KDE)
    # inputMethod = {
    #   enabled = "fcitx5";
    #   fcitx5.addons = with pkgs; [
    #     fcitx5-mozc
    #     fcitx5-gtk
    #   ];
    # };
  };

  sound.enable = true;
  security.rtkit.enable = true;

  services = {
    # Enable the X11 windowing system.
    xserver.enable = true;

    # Enable the Gnome Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    
    # Enable the KDE Plasma Desktop Environment.
    # xserver.displayManager.sddm.enable = true;
    # xserver.desktopManager.plasma5.enable = true;

    # Configure keymap in X11
    xserver = {
      layout = "gb";
      xkbVariant = "";
    };
   
   # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    flatpak.enable = true;
    printing.enable = true;
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    steam-hardware.enable = true;
  };  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daniel = {
    isNormalUser = true;
    description = "Daniel";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "games" "kvm" "libvirtd" "docker" ];
    packages = with pkgs; [
      # Add any extra packages you want installed for this user
      vscode
      cryptomator
      virt-manager
      ibus-mozc # japanese input (gnome)
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zsh
    nvim
    nano
    git
    distrobox
    gnomeExtensions.appindicator
    gnome.adwaita-icon-theme
  ];

  # Required for appindicator
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  programs = {
    zsh.enable = true;
    dconf.enable = true; # needed for virt-manager. https://nixos.wiki/wiki/virt-manager
  };

  virtualisation ={
    docker.enable = true;
    libvirtd.enable = true;
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;

    # allow wireguard - https://nixos.wiki/wiki/WireGuard
    firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
    };
  };
}
