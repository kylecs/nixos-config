{ pkgs, ... }:
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

  home.packages = with pkgs; [
    ghostty
    nerd-fonts.geist-mono


    nushell
    zoxide
    carapace
    starship
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

  home.file.".config/nvim/" = {
    source = ./dotfiles/nvim;
    recursive = true;
  };
}
