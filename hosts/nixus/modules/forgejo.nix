{ pkgs, config, ... }: {
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "nixus";
      url = "https://codeberg.org";
      tokenFile = config.age.secrets.forgejo-runner-token.path;
      labels = [
        "alpine-latest:docker://node:current-alpine"
        "nixos-latest:docker://nixos/nix"
        "nixus:host"
      ];
      hostPackages = with pkgs; [
        bash
        coreutils
        curl
        gawk
        gitMinimal
        gnused
        nodejs
        wget
        sudo
      ];
    };
  };

  # Podman config
  virtualisation = {
    containers = {
      enable = true;
      containersConf.settings = {
        network = {
          dns_bind_port = 20053;
        };
      };
    };

    podman = {
      enable = true;
      # Register `docker` alias for podman
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dive
    podman-tui
  ];

  networking.firewall.trustedInterfaces = [ "br-+" ];
}

