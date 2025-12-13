{ pkgs, ... }:
{
  #
  # Virt-manager
  #
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" ];
    qemu = {
      runAsRoot = false;
      swtpm.enable = true;
    };
  };
  users.groups.libvirtd.members = [ "caden" ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  # # Docker
  # virtualisation.docker = {
  #   enable = true;
  #   # rootless.enable = true;
  #   # rootless.setSocketVariable = true;
  #   storageDriver = "overlay2";
  # };
  # users.extraGroups.docker.members = [ "caden" ];

  # For UEFI
  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    quickemu

    distrobox
  ];
}
