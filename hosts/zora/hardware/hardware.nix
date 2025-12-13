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
  ];

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "ehci_pci"
    "usb_storage"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [
    "usb_storage"
    "sd_mod"
    "bfq" # BFQ scheduler
  ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.kernel.sysctl = {
    # Based on https://github.com/root0emir/ArchLinux-GamingPerformanceTuning/blob/main/Settings/sysctl.conf
    "vm.swappiness" = 25;
    "vm.vfs_cache_pressure" = 25;
    "net.ipv4.tcp_timestamps" = 1;
    "vm.max_map_count" = 16777216;
    # Tune dmesg to avoid printing kernel messages to console during gaming
    "kernel.printk" = "3 3 3 3";
    # Disable watchdogs
    "kernel.watchdog" = 0;
    "kernel.nmi_watchdog" = 0;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;

  #
  # Graphics
  #

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

}
