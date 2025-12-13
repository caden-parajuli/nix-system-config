{ pkgs, ... }:
let
  mcu = "rep2";
  serial = "/dev/serial/by-id/usb-MakerBot_Industries_The_Replicator_7523733353635141B170-if00";
  configFile = ././mightyboard;
  repKlipper = pkgs.klipper.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "dockterj";
      repo = "klipper";
      rev = "9f5cc340279b30a23b39449b9f1c1829e9d14941";
      sha256 = "sha256-PrQwj7rU1VMwEYODfG9QvcCeY7sAc9POqwJOsLEwNOE=";
    };
  };

  flashBinaries = [
    "lib/bossac/bin/bossac"
    "lib/hidflash/hid-flash"
    "lib/rp2040_flash/rp2040_flash"
  ];
  # The nixos-unstable branch of nixpkgs currently does not install klipper-firmware properly. 
  # See https://github.com/NixOS/nixpkgs/issues/241413.
  repFirmware = (pkgs.klipper-firmware.override {
    klipper = repKlipper;
    mcu = pkgs.lib.strings.sanitizeDerivationName mcu;
    firmwareConfig = configFile;
  }).overrideAttrs {
    installPhase = ''
      mkdir -p $out
      cp ./.config $out/config
      cp -r out/* $out/
      # cp out/klipper.bin $out/ || true
      # cp out/klipper.elf $out/ || true
      # cp out/klipper.uf2 $out/ || true

      mkdir -p $out/lib/

      ${
        with builtins;
        concatStringsSep "\n" (
          map (path: ''
            if [ -e ${path} ]; then
              mkdir -p $out/$(dirname ${path})
              cp -r ${path} $out/$(dirname ${path})
            fi
          '') flashBinaries
        )
      }
      rmdir $out/lib 2>/dev/null || echo "Flash binaries exist, not cleaning up lib/"
    '';
  };
  repFlash = (pkgs.klipper-flash.override {
    klipper = repKlipper;
    klipper-firmware = repFirmware;
    mcu = pkgs.lib.strings.sanitizeDerivationName mcu;
    flashDevice = serial;
    firmwareConfig = configFile;
  }).overrideAttrs {
      checkPhase = null;
    };
in {
  services.klipper = {
    package = repKlipper;
    user = "klipper";
    group = "klipper";
    enable = true;
    mutableConfig = false;
    configFile = ././rep2.conf;
    firmwares = {
      rep2 = {
        # enable = true;
        # Firmware must be flashed manually with the klipper repo
        enableKlipperFlash = false;
        configFile = ././mightyboard;
        serial = "/dev/serial/by-id/usb-MakerBot_Industries_The_Replicator_7523733353635141B170-if00";
      };
    };
  };

  services.moonraker = {
    enable = true;
    user = "klipper";
    group = "klipper";
    address = "0.0.0.0";
    analysis.enable = true;
    settings = {
      octoprint_compat = {
        enable_ufp = false;
        webcam_enabled = false;
      };
      authorization = {
        cors_domains = [
          "*.local"
          "*.nixus.local"
          "*://mainsail.nixus.local"
          "*.home.arpa"
          "*://mainsail.home.arpa"
        ];
        trusted_clients = [
          "192.168.16.0/24"
          "172.30.202.0/24"
        ];
      };
    };
  };

  users.users.klipper = {
    isSystemUser = true;
    group = "klipper";
  };
  users.groups.klipper.members = [ "klipper" ];
  services.mainsail = {
    enable = true;
    hostName = "mainsail.nixus.local";
  };
  # environment.systemPackages = [
  #   repFirmware
  #   repFlash
  # ];
}
