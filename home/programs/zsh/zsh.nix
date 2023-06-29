{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    SyntaxHighlighting = {
      enable = true;
    };
    
    initExtra = ''
      PATH=$HOME/.local/bin:$PATH
      eval "$(direnv hook zsh)"
    '';

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
  };
}
