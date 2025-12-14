{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./terminal.nix ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kyle";
  home.homeDirectory = "/home/kyle";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    nerd-fonts.fira-mono

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    alacritty-theme
    davinci-resolve

    omnisharp-roslyn

    # make an all lowercase variant that the neovim plugin works with.
    (writeShellScriptBin "omnisharp" ''
      #!${pkgs.bash}/bin/bash
      # This script just executes the real OmniSharp, passing all arguments along.
      exec ${pkgs.omnisharp-roslyn}/bin/OmniSharp "$@"
    '')

    vscode
    wl-clipboard
    prismlauncher
    # zulu25
    # jdk25_headless
    maven
    gnumake
    visualvm

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # disgusting hack
  home.activation.niri = lib.mkAfter ''
    rm -rf $HOME/.config/niri
    ln -sf $HOME/.config/nix/home-manager/niri $HOME/.config/niri
  '';

  # disgusting hack
  home.activation.waybar = lib.mkAfter ''
    rm -rf $HOME/.config/waybar
    ln -sf $HOME/.config/nix/home-manager/waybar $HOME/.config/waybar
  '';

  # disgusting hack
  home.activation.hypr = lib.mkAfter ''
    rm -rf $HOME/.config/hypr
    ln -sf $HOME/.config/nix/home-manager/hypr $HOME/.config/hypr
  '';

  # disgusting hack
  home.activation.fuzzel = lib.mkAfter ''
    rm -rf $HOME/.config/fuzzel
    ln -sf $HOME/.config/nix/home-manager/fuzzel $HOME/.config/fuzzel
  '';

  # disgusting hack
  home.activation.wlogout = lib.mkAfter ''
    rm -rf $HOME/.config/wlogout
    ln -sf $HOME/.config/nix/home-manager/wlogout $HOME/.config/wlogout
  '';

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kyle/etc/profile.d/hm-session-vars.sh
  #

  home.sessionVariables = {
    # EDITOR = "emacs";
    LESS = "-j.5 -R --mouse --wheel-lines=3";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
