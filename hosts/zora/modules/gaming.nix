{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-loader

    wine
    wayland
    rofi
    foot
    lutris
    protonup-qt
    protonup-rs
    (bottles.override {
      removeWarningPopup = true;
    })
    steam-run
  ];

  # programs.steam = {
  #   enable = true;
  #   gamescopeSession.enable = true;
  #   localNetworkGameTransfers.openFirewall = true;
  #   package = pkgs.steam.override {
  #     extraPkgs = pkgs: [ pkgs.attr.dev ];
  #   };
  # };
  # programs.appimage = {
  #   enable = true;
  #   binfmt = true;
  # };

  services.sunshine = {
    enable = false;
    package = pkgs.sunshine.override { cudaSupport = true; };
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      sunshine_name = "zora";
      # capture = "kms";
      adapter_name = "/dev/dri/renderD128";
    };
    applications = {
      apps = [
        {
          name = "Desktop";
          auto-detach = "true";
        }
      ];
    };
  };
}
