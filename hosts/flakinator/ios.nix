{
  pkgs,
  ...
}:
{
  # services.usbmuxd.enable = true;

  environment.systemPackages = [
    pkgs.usbmuxd
    pkgs.libimobiledevice
  ];
}
