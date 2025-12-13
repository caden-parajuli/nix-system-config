{
  description = "NixOS config flake";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    trusted-substituters = [ "https://yazi.cachix.org" "https://devenv.cachix.org" "https://cache.garnix.io" ];
    extra-substituters = [ "https://yazi.cachix.org" "https://devenv.cachix.org" "https://cache.garnix.io" ];
    extra-trusted-public-keys = [
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" 
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    # Unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zig.follows = "zig";
    };

    yazi.url = "github:sxyazi/yazi";
    yazi-rs = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    yazi-glow = {
      url = "github:Reledia/glow.yazi";
      flake = false;
    };
    yazi-what-size = {
      url = "github:pirafrank/what-size.yazi";
      flake = false;
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    webremote = {
      url = "github:caden-parajuli/webremote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      disko,
      agenix,
      yazi,
      catppuccin,
      ghostty,
      zig,
      quickshell,
      ...
    }:
    {
      # Please replace my-nixos with your hostname
      nixosConfigurations = {
        flakinator = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/flakinator/flakinator.nix

            disko.nixosModules.disko
            ./hosts/flakinator/disko-config.nix

            agenix.nixosModules.default

            catppuccin.nixosModules.catppuccin

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit inputs ghostty zig yazi;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users.caden.imports = [
                ./hosts/flakinator/users/caden/home.nix
                catppuccin.homeModules.catppuccin
                inputs.zen-browser.homeModules.twilight-official
              ];
            }
          ];
        };

        nixus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./hosts/nixus/nixus.nix

            disko.nixosModules.disko
            ./hosts/nixus/disko-config.nix

            agenix.nixosModules.default
          ];
        };
      };
    };
}
