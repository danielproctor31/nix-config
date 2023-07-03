# nix-config

## Setup

Enable Flakes:
```
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Install Home Manager:
```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

### Darwin

Install XCode command line tools and [Brew](https://brew.sh/):
```
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Build Nix Darwin with flakes:
```
nix build .#darwinConfigurations.<host>.system --extra-experimental-features "nix-command flakes"
```

## Usage

### NixOS
```
sudo nixos-rebuild switch --flake ./#<host>
```

### Darwin
```
./result/sw/bin/darwin-rebuild switch --flake ./#<host>
```

### Home Manager
```
nix run home-manager/master -- switch --flake ./#<host>
```

### direnv

Setup a `shell.nix` in your projects repo. Then run the following:
```
echo "use nix" > .envrc && direnv allow .
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
 - https://nixos.wiki/wiki/Development_environment_with_nix-shell
