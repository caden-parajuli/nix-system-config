{pkgs, ...}:
{
  # programs.uwsm = {
  #   enable = true;
  #   waylandCompositors = {
  #     hyprland = {
  #       prettyName = "Hyprland";
  #       binPath = "/run/current-system/sw/bin/Hyprland";
  #     };
  #   };
  # };
   
  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-loader

    wine
    wayland
    rofi
    # ghostty.packages.x86_64-linux.default
    foot
    lutris
    protonup-qt
    protonup-rs
    (bottles.override {
      removeWarningPopup = true;
    })
    # steam-run
  ];

  programs.hyprland = {
    enable = true;
    # withUWSM = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        # command = "uwsm start hyprland.desktop";
        command = "Hyprland";
        user = "caden";
      };
      default_session = initial_session;
    };
  };

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
    enable = true;
    package = pkgs.sunshine.override { cudaSupport = true; };
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      sunshine_name = "nixus";
      # capture = "kms";
      adapter_name = "/dev/dri/renderD128";
    };
    applications = {
      apps = [
        {
          name = "Desktop";
          auto-detach = "true";
        }
        {
          name = "Bottles";
          auto-detach = "true";
          cmd = ''bottles'';
        }
        # {
        #   name = "Blue Prince";
        #   cmd = ''bottles-cli -b "Blue" -p "BLUE PRINCE"'';
        # }
      ];
    };
  };
}
