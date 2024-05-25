{ ... }:
{

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nupdate = "sudo nixos-rebuild --flake /home/kyle/.config/nix#kyle-nix switch";
      nedit = "nvim /home/kyle/.config/nix/nixos/configuration.nix";
      hupdate = "home-manager --flake /home/kyle/.config/nix#kyle@kyle-nix switch";
      hedit = "nvim /home/kyle/.config/nix/home-manager/home.nix";
      nixdir = "cd /home/kyle/.config/nix";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "z" "git" ];
      theme = "robbyrussell";
    };
   };
}
