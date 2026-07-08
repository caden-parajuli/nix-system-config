{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "threadfin";
  version = "1.2.37";

  src = fetchFromGitHub {
    owner = "Threadfin";
    repo = "Threadfin";
    rev = finalAttrs.version;
    hash = "sha256-aPJy2Ilv8I4lj9n8Ml1vnstT8/XDu1AjhPPnqjb9oXA=";
  };

  deleteVendor = true;
  vendorHash = "sha256-q116Yt/D7knTyy04E6Wm/ZF93APmmPhPJpDch3e/fUY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "An M3U proxy for Kernel/Plex/Jellyfin/Emby based on xTeVe";
    homepage = "https://github.com/Threadfin/Threadfin";
    license = lib.licenses.mit;
    mainProgram = "threadfin";
  };
})
