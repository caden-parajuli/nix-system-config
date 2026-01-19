{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware/hardware.nix
    ./age.nix

    ./modules/desktop.nix

    ./modules/lang-servers.nix

    ./modules/gaming.nix
    ./modules/vnc.nix

    ./modules/wireguard.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    let
      pkgname = pkgs.lib.getName pkg;
    in
    (builtins.elem pkgname [
      "steam"
      "steam-unwrapped"
      "libnvjitlink"
      "cudnn"
      "libcublas"
      "libcufft"
      "libcurand"
      "libcusolver"
      "libcusparse"
      "libnpp"
      "libsciter"
    ])
    || (pkgs.lib.strings.hasPrefix "nvidia-" pkgname)
    || (pkgs.lib.strings.hasPrefix "cuda" pkgname);

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "zora";
  # networking.hostId = "2dc668d3";
  networking.usePredictableInterfaceNames = true;

  networking.modemmanager.enable = pkgs.lib.mkForce false;
  systemd.services.ModemManager = {
    enable = pkgs.lib.mkForce false;
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

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [
      "root"
      "@wheel"
    ];
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

  };

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
      "dialout"
      "kvm"
      "libvirtd"
      "networkmanager"
      "test"
      "uinput"
      "input" # For rdev
      "plugdev" # For rdev
      "uucp"
      "video"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    lshw
    fish
    nix-your-shell
    nix-prefetch

    # Core utilities
    coreutils
    curl
    stow
    ripgrep
    usbutils
    pciutils

    # Editing
    vim
    neovim
    tree-sitter

    # Dev
    git
    pkg-config
    gcc
    delta

    # Administration
    tmux
    iperf

    # Age secrets
    inputs.agenix.packages."${system}".default

    # Desktop
    pavucontrol
    firefox
  ];

  # udev rules
  services.udev = {
    enable = true;
    packages = with pkgs; [
      # BFQ Scheduler
      (pkgs.writeTextFile {
        name = "udisks2-rules-bfq-scheduler";
        text = ''
          ACTION=="add|change", KERNEL=="sd*[!0-9]|sr*", ATTR{queue/scheduler}="bfq"
        '';
        destination = "/etc/udev/rules.d/60-scheduler.rules";
      })
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Use fish
  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
    interactiveShellInit = (builtins.readFile ./config.fish);
    shellAbbrs = {
      sctl = "systemctl";
      ssctl = "sudo systemctl";
      gcam = "git commit --amend --no-edit";
      gst = "git status";
      gp = "git push";
      gf = "git fetch";
      gaa = "git add -A";
    };
    shellAliases = {
      nv = "nvim";
      n = "nvim";
    };
  };
  documentation.man.generateCaches = false; # fix annoyingly slow rebuilds due to fish default

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  #
  # Services
  #

  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SSH Server
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  users.users.caden.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJoquXO3IT2y+qCa03Gwd2ooW6UKrd26T+KHtrn2jcbA caden.parajuli@member.fsf.org"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjzvj8Do87gA5cXv2iH3WispS/MQDE2XBX1F2ylwR9q u0_a178"
  ];

  networking.firewall.allowedTCPPorts = [
    443 # NGINX
    80 # NGINX
    22 # SSH
  ];
  networking.firewall.allowedUDPPorts = [
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
