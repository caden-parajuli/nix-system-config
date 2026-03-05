{
  pkgs,
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./nvidia.nix
      # ./amdgpu.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages;
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "ehci_pci" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "usb_storage" "sd_mod" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Manage DNS ourself
  networking.networkmanager.dns = "none";
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.nameservers = [
    "127.0.0.1"
  ];


  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;


  #
  # Graphics
  #

   hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

}
