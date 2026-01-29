# ZSH shell configuration
# Oh-My-Zsh, syntax highlighting, and autosuggestions
{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "docker"
        "sudo"
        "systemd"
        "colored-man-pages"
        "command-not-found"
      ];
    };
    
    shellAliases = {
      # Modern CLI tool replacements
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      lt = "eza --tree --icons";
      cat = "bat";
      
      # System shortcuts
      rebuild = "sudo nixos-rebuild switch --flake \$HOME/code/nix-config";
      update = "pushd \$HOME/code/nix-config && nix flake update && sudo nixos-rebuild switch --flake . && popd";
      cleanup = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      
      # Common shortcuts
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Git shortcuts (in addition to oh-my-zsh git plugin)
      gs = "git status";
      gd = "git diff";
      gl = "git lg";
    };
    
    initExtra = ''
      # Additional zsh configuration
      # fzf integration is handled by programs.fzf.enableZshIntegration
    '';
  };
}
