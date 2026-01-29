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

### Fresh NixOS Installation

1. **Install NixOS** using the official installer with a minimal configuration

2. **Generate hardware configuration:**
   ```bash
   sudo nixos-generate-config --root /mnt
   ```

3. **Clone this repository:**
   ```bash
   git clone <your-repo-url> ~/.config/nix-config
   cd ~/.config/nix-config
   ```

4. **Copy hardware configuration:**
   ```bash
   # Copy the generated hardware-configuration.nix to your host directory
   sudo cp /etc/nixos/hardware-configuration.nix hosts/desktop/
   ```

5. **Initial build:**
   ```bash
   sudo nixos-rebuild switch --flake .#desktop
   ```

6. **Set user password:**
   ```bash
   sudo passwd daniel
   ```

7. **Reboot** into your new system

### Updating Existing System

Subsequent rebuilds (using ZSH alias from config):
```bash
rebuild  # Alias for: sudo nixos-rebuild switch --flake ~/.config/nix-config
```

## Update Strategy

### Safe Update Process

1. **Review changes before updating:**
   ```bash
   cd ~/.config/nix-config
   nix flake lock --update-input nixpkgs --dry-run
   ```

2. **Update and test:**
   ```bash
   # Update flake inputs
   nix flake update
   
   # Test without making permanent (reverts on reboot)
   sudo nixos-rebuild test --flake ~/.config/nix-config
   
   # If stable, apply permanently
   rebuild
   ```

3. **Keep a safe generation:**
   Don't delete all old generations immediately. Keep at least 2-3 previous working generations:
   ```bash
   # Delete generations older than 30 days (keeps recent ones)
   sudo nix-collect-garbage --delete-older-than 30d
   ```

### Selective Updates

Update specific inputs without touching others:
```bash
# Update only nixpkgs
nix flake lock --update-input nixpkgs

# Update only home-manager
nix flake lock --update-input home-manager

# Then rebuild
rebuild
```

## Rollback Procedures

### Quick Rollback

If something breaks after an update:

1. **Reboot and select previous generation** from the boot menu
2. Or rollback immediately:
   ```bash
   sudo nixos-rebuild switch --rollback
   ```

### Manual Generation Selection

```bash
# List all system generations
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Switch to specific generation (e.g., 42)
sudo nix-env -p /nix/var/nix/profiles/system --switch-generation 42
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

### Home Manager Rollback

```bash
# List home-manager generations
home-manager generations

# Activate specific generation
/nix/store/xxx-home-manager-generation/activate
```

### Testing Changes Before Applying

Test your configuration without committing to it:
```bash
# Test the configuration (doesn't persist after reboot)
sudo nixos-rebuild test --flake ~/.config/nix-config

# Boot into the new config once, then revert (safe testing)
sudo nixos-rebuild boot --flake ~/.config/nix-config

# If satisfied, make it permanent
rebuild
```

### Flake Lock Integrity

**Important:** The `flake.lock` file is committed to ensure reproducible builds. After updating:

```bash
# Update all inputs
nix flake update

# Or update specific input
nix flake lock --update-input nixpkgs

# Verify lock file is valid
nix flake metadata
```

Always commit `flake.lock` changes to maintain build reproducibility across systems.

## Development

### Enter Development Shell

```bash
nix develop
```

Provides: nixpkgs-fmt, nil (Nix LSP), statix (linter), nix-tree, nvd, nix-diff, deadnix

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
│   └── linux.nix         # Linux-specific settings (KDE Plasma, sound, networking)
├── hardware/
│   └── amd-gpu.nix       # AMD GPU hardware acceleration
├── hosts/
│   └── desktop/          # Desktop workstation configuration
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── overlays/
│   └── default.nix       # Custom package overlays
└── programs/
    ├── git/              # Git configuration and aliases
    ├── ssh/              # SSH client configuration
    └── zsh/              # ZSH with Oh-My-Zsh and modern CLI tools
```

## System Features

### Desktop Environment
- KDE Plasma 6 with Wayland
- SDDM display manager with Wayland support
- PipeWire audio
- Plymouth graphical boot

### Graphics
- AMD GPU with AMDGPU kernel driver (modular configuration)
- Mesa drivers with VA-API and VDPAU hardware acceleration
- Vulkan support with AMDVLK
- 32-bit support for gaming

### Virtualization & Containers
- Docker
- libvirtd (virt-manager)
- Distrobox

### Development Tools
- Nix development shell with formatters and linters
- direnv with nix-direnv for automatic environment loading
- nix-index for command-not-found functionality
- Modern CLI replacements (eza, bat, ripgrep, fd, fzf)
- Git with delta diff viewer
- btop for system monitoring
- tmux for terminal multiplexing

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

## Adding New Hosts

To add a new host (e.g., a laptop):

1. **Create host directory:**
   ```bash
   mkdir -p hosts/laptop
   ```

2. **Generate hardware configuration:**
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
   ```

3. **Create configuration.nix:**
   ```bash
   cat > hosts/laptop/configuration.nix << 'EOF'
   { config, lib, pkgs, ... }:
   {
     imports = [
       ../../common/core.nix
       ../../common/linux.nix
     ] ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

     networking.hostName = "laptop";
     system.stateVersion = "24.11";
     
     # Host-specific configuration here
   }
   EOF
   ```

4. **Add to flake.nix:**
   ```nix
   nixosConfigurations = {
     desktop = ...;
     
     laptop = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       inherit specialArgs;
       modules = [
         ./hosts/laptop/configuration.nix
         home-manager.nixosModules.home-manager
         (mkHomeManagerConfig (import ./home.nix))
       ];
     };
   };
   ```

5. **Build and switch:**
   ```bash
   sudo nixos-rebuild switch --flake .#laptop
   ```

## Troubleshooting

### Build Fails Due to Missing Hardware Config
```bash
# Generate hardware configuration for current system
sudo nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix
```

### System Won't Boot After Update

1. **Select previous generation** from GRUB/systemd-boot menu
2. Once booted, rollback:
   ```bash
   sudo nixos-rebuild switch --rollback
   ```
3. Review what changed:
   ```bash
   nvd diff /run/current-system /nix/var/nix/profiles/system-*-link
   ```

### Home Manager Activation Fails

```bash
# Check what failed
home-manager build

# Try with verbose output
home-manager switch -v

# Last resort: rollback home-manager
home-manager generations
# Copy the path and run: /nix/store/xxx-home-manager-generation/activate
```

### Service Fails to Start

```bash
# Check service status
systemctl status servicename

# View logs
journalctl -u servicename -f

# Check service configuration
systemctl cat servicename
```

### Check What Changed Between Generations
```bash
# Compare current and previous generations
nvd diff /run/current-system /run/booted-system

# List all generations
sudo nix-env -p /nix/var/nix/profiles/system --list-generations
```

### Rollback to Previous Generation
```bash
# List generations
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Rollback to previous
sudo nixos-rebuild switch --rollback

# Or boot into specific generation (shows in boot menu)
```

### Disk Space Issues
```bash
# Clean up old generations and garbage collect
sudo nix-collect-garbage -d
nix-collect-garbage -d

# Check store usage
nix path-info --closure-size -h /run/current-system

# See what's taking up space
nix-tree /run/current-system
```

### Flake Update Issues
```bash
# Update specific input only
nix flake lock --update-input nixpkgs

# Check flake metadata
nix flake metadata

# Show what would be updated
nix flake lock --update-input nixpkgs --dry-run
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [nix-direnv](https://github.com/nix-community/nix-direnv)
- [AMD GPU on NixOS](https://nixos.wiki/wiki/AMD_GPU)
