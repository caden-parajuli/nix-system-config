{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    # ./age.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  networking.hostName = "nixus";
  networking.hostId = "2dc668d3";

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
    hashedPassword = "$6$hhJulPyNEw9yGSoT$43QfQOucOm3wTFHHuxmj5hm0kOCV68jJ.GU95OTKIgvpjE4v6J.rALbudKjfwUh4QTXVhOHjLWiJzjJ.8oKUk1";
    # hashedPasswordFile = config.age.secrets.cadenPasswordHash.path;
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

  environment.systemPackages = with pkgs; [
    lshw
    fish
    nix-your-shell
    nix-prefetch

    # Core utilities
    coreutils
    git
    curl

    pkg-config

    # Desktop streaming
    wayland

    # Age secrets
    # inputs.agenix.packages."${system}".default

    # Docker
    devcontainer

    # Manpages
    man-pages
    man-pages-posix

    transmission_4
  ];

  # udev rules
  services.udev = {
    enable = true;
    packages = with pkgs; [
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Use fish
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  documentation.man.generateCaches = false; # fix annoyingly slow rebuilds due to fish default

  #
  # Services
  #

  # Pipewire (for wayland streaming)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SSH Server
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJoquXO3IT2y+qCa03Gwd2ooW6UKrd26T+KHtrn2jcbA"
  ];


  networking.firewall.allowedTCPPorts = [
    57766
    8080
    8000
    80
    22
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
