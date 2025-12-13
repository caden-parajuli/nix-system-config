{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Drawing
    inkscape-with-extensions

    # 3D CAD
    (blender.withPackages (ps: with ps; [
      pip
      pyrr
      pyopengl
      pyopengl-accelerate
      xxhash
      glfw
      pywayland
    ]))
    mcpp

    # Video editing
    losslesscut-bin

  ];
}
