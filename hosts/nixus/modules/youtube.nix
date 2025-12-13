{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vacuum-tube
  ];
}
