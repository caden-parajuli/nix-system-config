{
  description = "NixOS config flake";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [ "https://yazi.cachix.org" ];
    extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
  };

  inputs = {
    # NixOS official package source, using the nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs"; # Use system packages list where available
    };

    firefox.url = "github:nix-community/flake-firefox-nightly/master";

    yazi.url = "github:sxyazi/yazi";

    catppuccin.url = "github:catppuccin/nix";

    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs =
    inputs@{
      nixpkgs,
      catppuccin,
      home-manager,
      yazi,
      zig,
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
            ./configuration.nix

            catppuccin.nixosModules.catppuccin

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit inputs yazi zig;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users.caden.imports = [
                ./caden/home-configuration.nix
                catppuccin.homeManagerModules.catppuccin
              ];
            }
          ];
        };
      };
    };
}