{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./greetd.nix
    ./age.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Virtualisation
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  users.groups.libvirtd.members = [ "caden" ];
  # Docker
  virtualisation.docker = {
    enable = true;
    # rootless.enable = true;
    # rootless.setSocketVariable = true;
    storageDriver = "overlay2";
  };
  users.extraGroups.docker.members = [ "caden" ];

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "flakinator";
  networking.hosts = {
    "136.167.255.19" = [ "nixus.bc.edu" ];
  };

  users.groups.nginx = { };
  users.users.nginx = {
    group = "nginx";
    extraGroups = [ "www" ];
    isSystemUser = true;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";
  # Trust sudoers
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # Weekly store garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Enable store optimization
  nix.optimise.automatic = true;

  # Define user accounts.
  users.mutableUsers = false;
  users.users.caden = {
    isNormalUser = true;
    description = "Caden Parajuli";
    hashedPasswordFile = config.age.secrets.cadenPasswordHash.path;
    extraGroups = [
      "adbusers"
      "dialout"
      "docker"
      "kvm"
      "libvirtd"
      "vboxusers"
      "networkmanager"
      "test"
      "uinput"
      "input" # For rdev
      "plugdev" # For rdev
      "uucp"
      "video"
      "wheel"
      "wireshark"
    ];
  };

  # Packages installed in system profile.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];

  environment.systemPackages = with pkgs; [
    lshw
    fish
    nix-your-shell
    devenv
    nix-prefetch

    config.boot.kernelPackages.perf

    pkg-config

    # Desktop
    wayland
    hyprpaper
    hypridle
    hyprpolkitagent
    hyprland-qtutils
    xdg-desktop-portal

    pulseaudio

    # Networking
    wireshark
    openconnect

    # Disks
    gparted

    # Age secrets
    inputs.agenix.packages."${system}".default

    # Docker
    devcontainer

    # Manpages
    man-pages
    man-pages-posix

    # Games
    # protonup
    # lutris

    transmission_4-qt6
  ];

  # udev rules
  services.udev = {
    enable = true;
    packages = with pkgs; [
      android-udev-rules
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # ADB for Android/AOSP-based OSs
  programs.adb.enable = true;

  # Wireshark
  programs.wireshark.enable = true;

  # Hyprland
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  programs.hyprlock.enable = true;

  # Use fish
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  documentation.man.generateCaches = false; # fix annoyingly slow rebuilds due to fish default

  # Use Kanata for laptop keyboard
  services.kanata = {
    enable = true;
    package = pkgs.kanata-with-cmd;
    keyboards.laptop = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      configFile = (./. + "/laptop.kbd");
    };
  };

  # Games
  # programs.steam = {
  #   enable = true;
  #   gamescopeSession.enable = true;
  # };
  # programs.gamemode.enable = true;
  # programs.gamescope.enable = true;

  #
  # Services
  #

  # TLP Power saving
  services.tlp.enable = true;
  services.tlp.settings = {
    # START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
    STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  };

  # Pipewire audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
  };

  services.printing.enable = true;

  systemd = {
    targets = {
      hibernate = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      "hybrid-sleep" = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    57766
    8080
    8000
    80
  ];
  networking.firewall.allowedUDPPorts = [
    57766
    53
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
