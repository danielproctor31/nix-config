# ZSH shell configuration
# Oh-My-Zsh, syntax highlighting, and autosuggestions
{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nix-config";
      update = "cd ~/.config/nix-config && nix flake update && sudo nixos-rebuild switch --flake .";
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
      # Use fzf for better history search
      if [ -n "''${commands[fzf]}" ]; then
        source <(fzf --zsh)
      fi
    '';
  };
}
