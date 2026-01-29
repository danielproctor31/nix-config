# SSH configuration
# SSH client settings and key management
{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    
    # SSH connection settings
    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/%r@%h-%p";
    controlPersist = "10m";
    
    # Security settings
    hashKnownHosts = true;
    
    # Host-specific configurations
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };
      
      "gitlab.com" = {
        identityFile = "~/.ssh/gitlab";
        identitiesOnly = true;
      };
      
      # Example for personal servers
      # "homeserver" = {
      #   hostname = "192.168.1.100";
      #   user = "daniel";
      #   identityFile = "~/.ssh/homeserver";
      # };
    };
  };
  
  # Ensure SSH directory exists with correct permissions
  home.file.".ssh/sockets/.keep".text = "";
}
