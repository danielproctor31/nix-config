# nix-config

## TODO

- [ ] Disk Encryption - https://nixos.wiki/wiki/Full_Disk_Encryption
- [ ] Nix Darwin - https://github.com/LnL7/nix-darwin

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

### Home Manager
```
nix-shell -p home-manager
home-manager switch --flake ./#<name>
```

## Update Packages

```
nix flake update
```