{ pkgs, ... }:
{
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" ];
    qemu = {
      runAsRoot = false;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
      swtpm.enable = true;
    };
  };
  users.groups.libvirtd.members = [ "caden" ];
  # # Docker
  # virtualisation.docker = {
  #   enable = true;
  #   # rootless.enable = true;
  #   # rootless.setSocketVariable = true;
  #   storageDriver = "overlay2";
  # };
  # users.extraGroups.docker.members = [ "caden" ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # For UEFI
  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

  environment.systemPackages = with pkgs; [
    qemu
    quickemu
  ];
}
