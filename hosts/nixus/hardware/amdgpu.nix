{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.blacklistedKernelModules = [ "radeon" ];
  boot.kernelParams = [
    # "radeon.si_support=0"
    # "radeon.cik_support=0"
    "amdgpu.si_support=1"
    "amdgpu.cik_support=1"
  ];

  hardware.amdgpu.initrd.enable = true;

  hardware.graphics.extraPackages = [
    pkgs.rocmPackages.clr.icd
    # (pkgs.amdvlk.overrideAttrs (oldAttrs: rec {
    #   version = "2021.Q2.5";
    #   src = pkgs.fetchRepoProject {
    #     name = "amdvlk-src";
    #     manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    #     rev = "refs/tags/v-${version}";
    #     hash = "sha256-DWUuL/u+chWSlPbt6h3ufi+hiYqSVAHWK9is7XpaK24=";
    #   };
    # }))
  ];

  # For 32 bit applications 
  # hardware.graphics.extraPackages32 = with pkgs; [
  #   (pkgs.driversi686Linux.amdvlk.overrideAttrs (oldAttrs: rec {
  #     version = "2021.Q2.5";
  #     src = pkgs.fetchRepoProject {
  #       name = "amdvlk-src";
  #       manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
  #       rev = "refs/tags/v-${version}";
  #       hash = "sha256-DWUuL/u+chWSlPbt6h3ufi+hiYqSVAHWK9is7XpaK24=";
  #     };
  #   }))
  # ];

  environment.systemPackages = with pkgs; [
    clinfo
    pciutils
  ];

  # Force RADV
  environment.variables.AMD_VULKAN_ICD = "RADV";
}
