{ pkgs, ...}:

# From https://github.com/edolstra/nix-warez/blob/master/blender/flake.nix
let 
  mkBlender = { pname, version, src }:
    with pkgs;

    let
      libs =
        [ wayland libdecor xorg.libX11 xorg.libXi xorg.libXxf86vm xorg.libXfixes xorg.libXrender libxkbcommon libGLU libglvnd numactl SDL2 libdrm ocl-icd stdenv.cc.cc.lib openal ]
        ++ lib.optionals (lib.versionAtLeast version "3.5") [ xorg.libSM xorg.libICE zlib ];
    in

      stdenv.mkDerivation rec {
        inherit pname version src;

        buildInputs = [ makeWrapper ];

        preUnpack =
          ''
              mkdir -p $out/libexec
              cd $out/libexec
              '';

        installPhase =
          ''
              cd $out/libexec
              mv blender-* blender

              mkdir -p $out/share/applications
              mv ./blender/blender.desktop $out/share/applications/blender.desktop

              mkdir $out/bin

              makeWrapper $out/libexec/blender/blender $out/bin/blender \
              --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:${lib.makeLibraryPath libs}

              patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              blender/blender

              patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"  \
              $out/libexec/blender/*/python/bin/python3*
              '';

        meta.mainProgram = "blender";
      };

  blender_4_5 = mkBlender {
    pname = "blender-bin";
    version = "4.5.2";
    src = import <nix/fetchurl.nix> {
      url = "https://ftp.nluug.nl/pub/graphics/blender/release/Blender4.5/blender-4.5.2-linux-x64.tar.xz";
      hash = "sha256-u6U2GSlJHM1pN0uTxUfwh/CcnqrF2MyW2jIQSFwT1E8=";
    };
  };

in {
  environment.systemPackages = with pkgs; [
    xorg.libX11
    blender_4_5
  ];
}
