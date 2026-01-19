{pkgs, ...}:
{
  services.displayManager = {
    plasma6.enable = true;
    sddm.enable = true;
  };
}
