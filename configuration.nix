# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./nvidia.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "caden" ];

  virtualisation.docker = {
    rootless.enable = true;
    enable = true;
    storageDriver = "overlay2";
  };
  users.extraGroups.docker.members = [ "caden" ];

  networking.hostName = "flakinator"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable weekly store garbage collection
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
    extraGroups = [
      "networkmanager"
      "wireshark"
      "test"
      "uinput"
      "video"
      "wheel"
      "dialout"
      "uucp"
      "docker"
    ];
    hashedPassword = "$y$j9T$ap.w7FUG2UQY5svZmhmum0$hmvi2xmIdsO7fVQ50u1c0fY/MzwRou3GdGeygh/O9JA";
  };


  # Packages installed in system profile.
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    lshw
    fish
    nix-your-shell

    config.boot.kernelPackages.perf

    wayland
    hyprpaper
    hypridle
    # hyprpolkitagent # Needs nix update

    openconnect
    pulseaudio

    # Networking
    wireshark

    gparted

    # Docker
    devcontainer

    # Manpages
    man-pages
    man-pages-posix

    # Games
    protonup
    lutris

    transmission_4-qt6
  ];

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Wireshark
  programs.wireshark.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  programs.hyprlock.enable = true;

  # Use fish
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

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
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  #
  # Services
  #

  # TLP Power saving
  services.tlp.enable = true;

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
