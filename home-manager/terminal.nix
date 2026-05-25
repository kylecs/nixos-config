{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./dotfiles/tmux/tmux.conf;
    plugins = with pkgs; [
      tmuxPlugins.catppuccin
      tmuxPlugins.sensible
      tmuxPlugins.tmux-which-key
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # nix aliases
      nupdate = "sudo nixos-rebuild --flake /home/kyle/.config/nix#kyle-nix switch";
      nedit = "nvim /home/kyle/.config/nix/nixos/configuration.nix";
      hupdate = "home-manager --flake /home/kyle/.config/nix#kyle@kyle-nix switch";
      hedit = "nvim /home/kyle/.config/nix/home-manager/home.nix";
      nix-dir = "cd /home/kyle/.config/nix";
      nix-shell = "nix-shell --run zsh";
      nix-dev = "nix develop -c $SHELL";

      # eza
      # ls = "eza --icons";
      # ll = "eza -l --icons";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "z"
        "git"
      ];
    };

  };

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
  };

  home.packages = with pkgs; [
    ghostty
    # eza
  ];

  home.file.".config/ghostty" = {
    source = ./dotfiles/ghostty;
    recursive = true;
    force = true;
  };

  home.file.".config/nushell" = {
    source = ./dotfiles/nushell;
    recursive = true;
    force = true;
  };

  home.file.".config/kitty" = {
    source = ./dotfiles/kitty;
    recursive = true;
    force = true;
  };

  # neovim dotfiles
  home.activation.nvim = lib.mkAfter ''
    ln -snf $HOME/.config/nix/home-manager/dotfiles/nvim $HOME/.config/nvim
  '';
}
