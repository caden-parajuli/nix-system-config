{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
    rage

    emacs-pgtk

    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
      ]
    ))

    libreoffice-qt6-still
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };
}
