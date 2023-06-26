{ config, pkgs, ... }:
{
    imports = [ ./base.nix ];

    home.username = "dan";
    home.homeDirectory = "/Users/dan";
}
