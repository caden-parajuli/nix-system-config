{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nvim

    neovim
    luajitPackages.luautf8 # Nvim Agda
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
