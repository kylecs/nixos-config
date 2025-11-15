{...}:
{
 programs.alacritty = {
    enable = true;
    settings = {

      shell.program = "tmux";
      font = {
        size = 16;
        normal = {
           family = "Fira Mono Nerd Font";
           style = "Regular";
         };
         bold = {
           family = "Fira Mono Nerd Font";
           style = "Bold";
         };
         italic = {
           family = "Fira Mono Nerd Font";
           style = "Italic";
         };
         bold_italic = {
           family = "Fira Mono Nerd Font";
           style = "Bold Italic";
         };
        };
      import = ["~/.nix-profile/catppuccin.toml"];
    };
  };
 
}
