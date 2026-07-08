{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays =
    let
      localPackagesOverlay = final: prev: {
        threadfin = (prev.callPackage ./../packages/threadfin.nix { });
      };
    in
    [
      localPackagesOverlay
    ];
}
