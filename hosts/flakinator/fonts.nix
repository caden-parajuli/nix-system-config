{
  pkgs,
  ...
}:
{
  # Fonts
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.fira-code
      noto-fonts
      liberation_ttf

      winePackages.fonts

      texlivePackages.lobster2
      texlivePackages.calligra
    ];
  };
}
