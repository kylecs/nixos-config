{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      set number
      set cc=120
      set shiftwidth=4
      set clipboard+=unnamedplus
    '';

    plugins = with pkgs.vimPlugins; [
      telescope-nvim
    ];
  };
}