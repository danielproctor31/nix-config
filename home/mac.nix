{ config, pkgs, ... }:
{
    imports = [ ./base.nix ];

    home.username = "daniel";
    home.homeDirectory = "/Users/daniel";
}
