{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    steam
    spotify
    vlc
    (prismlauncher.override {
      jdks = [
        openjdk25
        jdk21
        jdk17
        jdk8
      ];
    })
    vesktop
  ];
}
