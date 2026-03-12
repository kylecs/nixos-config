{
  pkgs,
  lib,
  ...
}:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.vterm
    ];
  };

  home.packages = with pkgs; [
    omnisharp-roslyn
    vscode
    apktool
    bruno
    maven
    gnumake
    visualvm
    openjdk25
    htop
    obsidian
    claude-code

    lua-language-server
    stylua
    fd
    nil
    wgsl-analyzer
    ripgrep
    nixfmt

    # make an all lowercase variant that the neovim plugin works with.
    (writeShellScriptBin "omnisharp" ''
      #!${pkgs.bash}/bin/bash
      # This script just executes the real OmniSharp, passing all arguments along.
      exec ${pkgs.omnisharp-roslyn}/bin/OmniSharp "$@"
    '')
  ];


  # doom emacs dotfiles symlink
  home.activation.doomEmacs = lib.mkAfter ''
    ln -sf $HOME/.config/nix/home-manager/dotfiles/doomemacs $HOME/.config/doom
  '';
}
