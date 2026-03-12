{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    wlogout
    wl-clipboard
    waybar
    fuzzel
    swaybg
    playerctl
    hyprlock
    hypridle
    pavucontrol
  ];
}
