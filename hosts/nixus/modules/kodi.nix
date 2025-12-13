{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ((pkgs.kodi-wayland
      .override {
        vdpauSupport = true;
      })
      .withPackages (kodiPkgs: with kodiPkgs; [
        sendtokodi
        # jellyfin
        sponsorblock

        inputstreamhelper
        inputstream-adaptive
        inputstream-ffmpegdirect
        inputstream-rtmp
        libretro

        # For skin
        jurialmunkey
        robotocjksc
        texturemaker
      ]))
  ];

  users.users.kodi = {
    group = "media";
    extraGroups = [ "video" ];
    isNormalUser = true;
  };

  services.avahi = {
    enable = true;
    openFirewall = true;
  };
}
