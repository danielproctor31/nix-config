# Git configuration
# Version control settings, aliases, and user information
{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Daniel Proctor";
    userEmail = "dan@danielproctor.dev";
    
    aliases = {
      # Basic shortcuts
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      
      # Undo operations
      unstage = "reset HEAD --";
      undo = "reset --soft HEAD^";
      amend = "commit --amend --no-edit";
      
      # Viewing
      last = "log -1 HEAD";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      graph = "log --graph --oneline --decorate --all";
      tree = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
      
      # Working with branches
      branches = "branch -a";
      tags = "tag -l";
      remotes = "remote -v";
      
      # Stash operations
      stashes = "stash list";
      
      # Quick operations
      pushf = "push --force-with-lease";
      sync = "!git fetch && git pull --rebase";
    };

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      push.autoSetupRemote = true;
      push.default = "current";
      pull.rebase = true;
      
      # Better diff algorithm
      diff.algorithm = "histogram";
      
      # Reuse recorded resolution of conflicted merges
      rerere.enabled = true;
      
      # Use delta as diff pager
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      
      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
      
      merge.conflictstyle = "diff3";
    };
    
    ignores = [
      # OS files
      ".DS_Store"
      "Thumbs.db"
      
      # Editor files
      ".vscode/"
      ".idea/"
      "*.swp"
      "*.swo"
      "*~"
      
      # Build artifacts
      "result"
      "result-*"
      
      # Environment
      ".env"
      ".env.local"
    ];
  };
}