# nix-config

Personal NixOS configuration using Nix flakes and home-manager.

## System Overview

- **desktop**: High-performance AMD GPU workstation running KDE Plasma 6

## Prerequisites

Enable Flakes:
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## Installation

### NixOS

Clone this repository:
```bash
git clone <your-repo-url> ~/.config/nix-config
cd ~/.config/nix-config
```

Initial build:
```bash
sudo nixos-rebuild switch --flake .
```

Subsequent rebuilds (using ZSH alias from config):
```bash
rebuild  # Alias for: sudo nixos-rebuild switch --flake ~/.config/nix-config
```

## Development

### Enter Development Shell

```bash
nix develop
```

Provides: nixpkgs-fmt, nil (Nix LSP), statix (linter), nix-tree, nvd, deadnix

### Format Code

```bash
nix fmt
```

### Update Dependencies

```bash
nix flake update
# Or use the ZSH alias:
update  # Runs flake update and rebuilds system
```

## Configuration Structure

```
├── flake.nix              # Main flake configuration
├── home.nix               # Home-manager user configuration
├── common/
│   ├── core.nix          # Platform-agnostic Nix settings
│   └── linux.nix         # Linux-specific settings (KDE Plasma, AMD GPU, sound, networking)
├── hosts/
│   └── desktop/          # Desktop workstation configuration
│       ├── configuration.nix
│       └── hardware-configuration.nix
└── programs/
    ├── git/              # Git configuration and aliases
    └── zsh/              # ZSH with Oh-My-Zsh and modern CLI tools
```

## System Features

### Desktop Environment
- KDE Plasma 6 with Wayland
- SDDM display manager
- PipeWire audio

### Graphics
- AMD GPU with AMDGPU kernel driver
- Mesa drivers with VA-API and VDPAU hardware acceleration
- 32-bit support for gaming

### Virtualization & Containers
- Docker
- libvirtd (virt-manager)
- Distrobox

### Development Tools
- Nix development shell with formatters and linters
- direnv for automatic environment loading
- Modern CLI replacements (eza, bat, ripgrep, fd, fzf)
- Git with delta diff viewer

## Useful Commands

Built-in ZSH aliases:
```bash
rebuild  # Rebuild NixOS configuration
update   # Update flake inputs and rebuild
cleanup  # Run garbage collection
```

### direnv

Setup automatic environment loading in projects:
```bash
echo "use nix" > .envrc && direnv allow .
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [nix-direnv](https://github.com/nix-community/nix-direnv)
- [AMD GPU on NixOS](https://nixos.wiki/wiki/AMD_GPU)
