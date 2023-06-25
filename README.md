# nix-config

## TODO

- [ ] Nix Darwin - https://github.com/LnL7/nix-darwin
- [ ] Direnv - https://github.com/nix-community/nix-direnv

## Setup

Install Home Manager:
```
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --update
```

## Usage

### NixOS

Enable Flakes:
```
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Run:
```
sudo nixos-rebuild switch --flake ./#<name>
```

### Darwin

TODO

### Home Manager
```
nix-shell -p home-manager
home-manager switch --flake ./#<name>
```

## Update Packages

```
nix flake update
```

Links:
 - https://nixos.wiki/wiki/Overview_of_the_NixOS_Linux_distribution
 - https://nixos.wiki/wiki/Flakes
 - https://github.com/LnL7/nix-darwin
 - https://nixos.wiki/wiki/Nvidia
 - https://nixos.wiki/wiki/Full_Disk_Encryption
 - https://nix-community.github.io/home-manager/index.html
 - https://github.com/nix-community/nix-direnv
