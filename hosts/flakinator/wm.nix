{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    wayland
    wayland-protocols
    wayland-utils
    glfw

    # hyprpaper
    hypridle
    hyprpolkitagent
    hyprland-qtutils

    river
    inputs.river-kwm.packages.x86_64-linux.default

    xdg-desktop-portal
  ];

  xdg.portal.wlr.enable = true;

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        # binPath = "/run/current-system/sw/bin/Hyprland";
        binPath = "${pkgs.hyprland}/bin/Hyprland";
      };
      sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
      river = {
        prettyName = "River";
        comment = "Sway compositor managed by UWSM";
        binPath = "${pkgs.river}/bin/river";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  programs.hyprlock.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [
      # "--unsupported-gpu"
    ];
    extraPackages = with pkgs; [
      swayidle
      swaylock
    ];
  };

}
