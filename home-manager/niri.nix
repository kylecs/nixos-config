
{
  lib,
  ...
}:
{
  # symlink various niri or niri-adjacent configs
  home.activation.niri = lib.mkAfter ''
    ln -snf $HOME/.config/nix/home-manager/dotfiles/niri $HOME/.config/niri
  '';
  home.activation.waybar = lib.mkAfter ''
    ln -snf $HOME/.config/nix/home-manager/dotfiles/waybar $HOME/.config/waybar
  '';
  home.activation.hypr = lib.mkAfter ''
    ln -snf $HOME/.config/nix/home-manager/dotfiles/hypr $HOME/.config/hypr
  '';
  home.activation.fuzzel = lib.mkAfter ''
    ln -snf $HOME/.config/nix/home-manager/dotfiles/fuzzel $HOME/.config/fuzzel
  '';
  home.activation.wlogout = lib.mkAfter ''
    ln -snf $HOME/.config/nix/home-manager/dotfiles/wlogout $HOME/.config/wlogout
  '';
}
