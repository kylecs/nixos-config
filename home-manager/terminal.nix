{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ghostty
  ];

  home.file = {
    ".config".source = builtins.readFile ./dotfiles;
    ".config".recursive = true;
  };
}
