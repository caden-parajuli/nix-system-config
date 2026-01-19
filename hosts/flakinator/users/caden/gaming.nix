{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wine-staging
    wine64Packages.waylandFull
    winetricks
    protonup-qt
    bottles
    fuse-overlayfs
    bubblewrap
    # lutris
    # (retroarch.withCores (
    #   cores: with cores; [
    #     snes9x
    #     # citra
    #     # dolphin
    #
    #     desmume # TODO: Get dumps for melonds
    #   ]
    # ))
    moonlight-qt

    steam-run
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
        pkgs.gamemode
      ];
    })
  ];
}
