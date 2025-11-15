{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    ghostty
  ];

  home.file.".config/tmux" = {
    source = ./dotfiles/tmux;
    recursive = true;
  };

  # home.file = {
  #   ".config/tmux".source = builtins.readFile ./dotfiles/tmux;
  #   ".config/tmux".recursive = true;
  # };
}
