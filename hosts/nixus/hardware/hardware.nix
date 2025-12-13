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

  # swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


  #
  # Graphics
  #

   hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

}
