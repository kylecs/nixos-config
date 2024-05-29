{...}:
{
 programs.alacritty = {
    enable = true;
    settings = {
      font.size = 14;
      shell.program = "tmux";

      # not sure how to refer to this properly
      # TODO update to toml
      # import = ["~/.nix-profile/argonaut.yaml"];
    };
  };
 
}
