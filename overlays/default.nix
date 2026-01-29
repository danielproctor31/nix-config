# Custom package overlays
# Use this to modify or add custom packages
{ inputs, ... }:
{
  # Example: Override package versions
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     # Example: Use a specific version of a package
  #     # somepackage = prev.somepackage.overrideAttrs (old: {
  #     #   version = "x.y.z";
  #     # });
  #     
  #     # Example: Add custom packages
  #     # my-custom-package = prev.callPackage ./pkgs/my-custom-package { };
  #   })
  # ];
  
  # Commonly used overlays from the community
  nixpkgs.overlays = [
    # Add community overlays here
    # inputs.nur.overlay  # Nix User Repository
    # inputs.neovim-nightly.overlay
  ];
}
