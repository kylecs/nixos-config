
{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./.wezterm.lua;
    # plugins = with pkgs; [
    #   tmuxPlugins.catppuccin
    #   tmuxPlugins.sensible
    #   tmuxPlugins.vim-tmux-navigator
    #   tmuxPlugins.resurrect
    # ];
  };
}
