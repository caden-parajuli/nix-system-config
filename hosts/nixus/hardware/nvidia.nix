{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = ["nvidia"];

  boot.initrd.availableKernelModules = [ "nvidia_drm" "nvidia_modeset" "nvidia" "nvidia_uvm" ];

  hardware.nvidia = {
    package =
      # config.boot.kernelPackages.nvidiaPackages.stable;
      config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "580.95.05";
        sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
        sha256_aarch64 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        openSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        settingsSha256 = "sha256-um53cr2Xo90VhZM1bM2CH4q9b/1W2YOqUcvXPV6uw2s=";
        persistencedSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };

    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  environment.systemPackages = with pkgs; [
    vdpauinfo             # sudo vainfo
    libva-utils           # sudo vainfo
    pkgsCuda.cudatoolkit
    # pkgsCuda.cudnn
  ];

  hardware.graphics.extraPackages = with pkgs; [
    # libva-vdpau-driver
    # nvidia-vaapi-driver
  ];

  environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";
  environment.sessionVariables.VDPAU_DRIVER = "nvidia";
}
