{ pkgs, ... }:
{

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nupdate = "sudo nixos-rebuild --flake /home/kyle/.config/nix#kyle-nix switch";
      nedit = "nvim /home/kyle/.config/nix/nixos/configuration.nix";
      hupdate = "home-manager --flake /home/kyle/.config/nix#kyle@kyle-nix switch";
      hedit = "nvim /home/kyle/.config/nix/home-manager/home.nix";
      nix-dir = "cd /home/kyle/.config/nix";
      nix-shell = "nix-shell --run zsh";
      nix-dev = "nix develop -c $SHELL";
    }; 
    
    # plugins = [
    #   {
    #     name = "vi-mode";
    #     src = pkgs.zsh-vi-mode;
    #     file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    #   }
    # ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "z"
        "git"
      ];
      theme = "robbyrussell";
    };
   };
}
