{ config, pkgs, ... }:
{
    imports = [ ./base.nix ];

    home.username = "daniel";
    home.homeDirectory = "/home/daniel";
}
