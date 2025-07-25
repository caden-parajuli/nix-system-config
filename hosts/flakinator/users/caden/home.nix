{
  inputs,
  pkgs,
  ghostty,
  zig,
  quickshell,
  ...
}:

let
  system = "x86_64-linux";
in
rec {
  imports = [
    ./yazi.nix
  ];

  nix.settings = {
    extra-substituters = [ "https://yazi.cachix.org" ];
    extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
  };

  catppuccin = {
    enable = true;

    gtk.enable = false;
    kvantum.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
    waybar.enable = false;
  };

  programs = {
    home-manager.enable = true;

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    nushell = {
      enable = true;
      extraConfig = "source /home/caden/.config/nushell/my_init.nu";
      extraEnv = "$env.CARAPACE_BRIDGES = 'fish,bash,inshellisense'";
      shellAliases = {
        vim = "nvim";
        nv = "nvim";
        n = "nvim";
      };
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;

      interactiveShellInit = (builtins.readFile ./config.fish);
      shellAbbrs = {
        sctl = "systemctl";
        ssctl = "sudo systemctl";
        gcam = "git commit --amend --no-edit";
      };
      shellAliases = {
        vim = "nvim";
        nv = "nvim";
        n = "nvim";
      };

      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "puffer";
          src = pkgs.fishPlugins.puffer.src;
        }
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
      ];
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = false;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    # style = {
    #   package = pkgs.catppuccin-kvantum;
    #   name = "kvantum";
    # };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 16;
    };
  };

  fonts.fontconfig.enable = true;

  home = rec {
    stateVersion = "24.05";
    username = "caden";
    homeDirectory = "/home/caden";

    sessionPath = [ "${homeDirectory}/.cargo/bin" ];

    sessionVariables = {
      # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${homeDirectory}/.steam/root/compatibilitytools.d";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";

      # Firefox
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";

      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };

    pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 16;
    };

    packages =
      let
        # nixpkgs appflowy is out of date
        my-appflowy = pkgs.appflowy.overrideAttrs (oldAttrs: rec {
          inherit (oldAttrs) pname;
          version = "0.8.3";
          mimeTypes = [ "x-scheme-handler/appflowy-flutter" ];
          src = pkgs.fetchzip {
            url = "https://github.com/AppFlowy-IO/appflowy/releases/download/${version}/AppFlowy-${version}-linux-x86_64.tar.gz";
            hash = "sha256-zIxNk7uwVeJlMzxi7Gxbp1TkHt5PBKnDOw7Qq5ReyFI=";
            stripRoot = false;
          };
          # Fix browser redirect. This fix has landed in nixpkgs:master
          desktopItems = [
            (pkgs.makeDesktopItem {
              name = "appflowy";
              desktopName = "AppFlowy";
              comment = "An open-source alternative to Notion";
              exec = "appflowy %U";
              icon = "appflowy";
              categories = [ "Office" ];
              mimeTypes = [ "x-scheme-handler/appflowy-flutter" ];
            })
          ];
        });
        quickshellPackage = inputs.quickshell.packages.${pkgs.system}.default;
        qtEnv = with pkgs.qt6; env "qt-custom-${qtbase.version}" [
          qtdeclarative
        ];

      in
      with pkgs;
      [
        #
        # Dev
        #

        # General
        ghostty.packages.x86_64-linux.default
        git
        delta
        gnumake
        tree-sitter
        vscode-langservers-extracted
        stow
        prettierd

        # C
        clang-tools
        llvmPackages.libcxxClang
        lld

        # Rust
        rustup

        # OCaml
        opam
        ocamlPackages.ocaml-lsp

        # Lua
        lua-language-server
        luajit
        luajitPackages.luautf8

        # Nix
        nil
        nixfmt-rfc-style

        # Python
        python312
        python312Packages.setuptools
        python312Packages.pygments
        python312Packages.pylatexenc

        # Nim
        nim
        nimlangserver

        # Zig
        zig.packages.${pkgs.system}.master

        # Haskell
        haskellPackages.haskell-language-server
        haskellPackages.stack
        haskell.compiler.ghc96

        # LaTeX
        texlab

        # JS
        nodejs-slim # I really only need this for tree-sitter

        # Profiling / Debugging
        heaptrack
        lldb
        valgrind

        # Text editing
        neovim
        stow

        # my-appflowy

        #
        # GUI Apps
        #

        alacritty
        foot
        rofi-wayland
        rofi-calc
        # tauon
        jellyfin-tui
        xarchiver
        zathura
        signal-desktop
        blender
        
        # Browser
        floorp


        #
        # Gui app required tools
        #

        # for waybar
        font-awesome
        # For xarchiver
        p7zip
        unar
        # For zathura
        xdotool

        #Gaming
        wine-staging
        wine64Packages.waylandFull
        winetricks
        protonup-qt
        bottles
        fuse-overlayfs
        bubblewrap
        lutris
        (retroarch.withCores (cores: with cores; [
          snes9x
          citra
          dolphin

          desmume # TODO: Get dumps for melonds
        ]))
        moonlight-qt

        #
        # Desktop tools
        #

        # For Hyprland
        hyprpicker
        hyprsunset
        wl-clipboard-rs
        hyprls
        # Screenshot
        grim
        slurp
        imagemagick
        # Status
        avizo
        waybar
        swaynotificationcenter
        # Email
        thunderbird

        # Quickshell
        qtEnv
        quickshellPackage
        qt6Packages.qtstyleplugin-kvantum
        kdePackages.networkmanager-qt
        kdePackages.qt6ct

        # Control
        playerctl
        nwg-displays
        networkmanagerapplet
        pavucontrol
        easyeffects
        wireguard-ui

        # Theming
        libsForQt5.qt5ct
        catppuccin-qt5ct
        # libsForQt5.qtstyleplugin-kvantum
        # kdePackages.qtstyleplugin-kvantum

        # Daemons
        nginx

        # Hardware
        kicad
        espflash

        # Reverse engineering / analysis
        aflplusplus
        ghidra

        #
        # Terminal apps
        #

        fish
        comma
        bat
        glow
        ripgrep
        ripgrep-all
        ran
        jq
        grc
        yt-dlp
        psmisc
        tlrc
        git-open
        xxh
        sshs
        feh
        ffmpeg-full

        # Nushell

        # nushellPlugins.net
        # nushellPlugins.gstat

        # Networking
        dig
        inetutils

        # Deployment
        flyctl

        # Fonts
        nerd-fonts.fira-code

        # Misc
        xdg-utils
      ];
  };
  systemd.user.sessionVariables = home.sessionVariables;

}
