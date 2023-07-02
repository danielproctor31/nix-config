{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Daniel Proctor";
    userEmail = "dan@danielproctor.dev";
    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
    };

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "vim";
    };
    
    ignores = [
    ];
  };
}