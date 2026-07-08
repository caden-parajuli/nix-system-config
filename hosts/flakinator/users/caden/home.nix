{
  inputs,
  pkgs,
  ghostty,
  zig,
  localshare,
  ...
}:

rec {
  imports = [
    ./editors.nix
    ./yazi.nix
    ./art.nix
    ./gaming.nix
  ];

  nix.settings = {
    extra-substituters = [ "https://yazi.cachix.org" "https://cache.iog.io" ];
    extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
  };

  catppuccin = {
    enable = true;
    autoEnable = true;

    kvantum.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
  };

  programs = {
    home-manager.enable = true;

    nix-index = {
      enable = true;
      enableFishIntegration = true;
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
        e = "emacs -nw";
        sl = "ls";
        lah = "ls -lah";
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
      enableFishIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zen-browser = {
      enable = true;
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        # DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = false;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        advanced-scene-switcher
      ];
    };

    rofi = {
      enable = true;
      package = pkgs.rofi;
      plugins = with pkgs; [
        rofi-calc
      ];
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
  };

  gtk = rec {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    gtk4.theme = theme;
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
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
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
        quickshellPackage = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
        qtEnv =
          with pkgs.qt6;
          env "qt-custom-${qtbase.version}" [
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
        nixfmt

        # Python
        uv
        (python313.withPackages (
          ps: with ps; [
            pynvim

            tkinter
            pip
            setuptools
            tkinter
            pygments
            pylatexenc
            glfw
            pygame
          ]
        ))

        # Nim
        nim
        nimlangserver

        # Zig
        zig.packages.${pkgs.stdenv.hostPlatform.system}.master

        # Haskell
        haskellPackages.stack
        # see https://nixos.org/manual/nixpkgs/unstable/#haskell-language-server
        # haskellPackages.haskell-language-server
        # haskell.compiler.ghc912

        # LaTeX
        texlab

        # Typst
        typst
        tinymist
        websocat

        # JS
        nodejs-slim # I really only need this for tree-sitter

        # Profiling / Debugging
        heaptrack
        lldb
        valgrind

        stow

        #
        # GUI Apps
        #

        foot
        vlc
        xarchiver
        zathura

        # Alternative Browsers
        qutebrowser
        ungoogled-chromium

        #
        # Gui app required tools
        #

        # For xarchiver
        p7zip
        unar
        # For zathura (is this still necessary on Wayland?)
        xdotool

        #
        # Desktop tools
        #

        # Hyprland
        hyprls

        #Sway
        wlsunset
        gtklock
        wayland
        wayland-utils

        # Clipboard
        wl-clipboard-rs
        wl-clip-persist
        # Screenshot
        grim
        slurp
        imagemagick
        # Status
        avizo
        swaynotificationcenter

        # Email
        thunderbird

        # 3D Printing
        orca-slicer

        # Quickshell
        qtEnv
        quickshellPackage

        # VNC
        remmina

        # Theming
        libsForQt5.qt5ct
        catppuccin-qt5ct
        qt6Packages.qtstyleplugin-kvantum
        kdePackages.qt6ct
        dracula-theme

        # Control
        playerctl
        nwg-displays
        networkmanagerapplet
        pavucontrol
        easyeffects
        wireguard-ui
        cyme
        kdePackages.networkmanager-qt

        # Daemons
        nginx

        # Reverse engineering
        # aflplusplus
        # ghidra

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
        psmisc
        tlrc
        git-open
        xxh
        sshs
        feh
        caligula
        pastel
        tree

        # Networking
        dig
        inetutils
        nmap

        # Music
        ffmpeg-full
        jellyfin-tui
        yt-dlp

        # Deployment
        # flyctl

        # Misc
        xdg-utils
        inotify-tools
        threadfin

        # My tools
        localshare.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
  };
  systemd.user.sessionVariables = home.sessionVariables;

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "zen-twilight.desktop";
        "text/plain" = "nvim.desktop.desktop";
        "x-scheme-handler/http" = "zen-twilight.desktop";
        "x-scheme-handler/https" = "zen-twilight.desktop";
        "x-scheme-handler/unknown" = "nvim.desktop";
        "application/octet-stream" = "nvim.desktop";
        "text/x-csrc" = "nvim.desktop";
        "text/x-chdr" = "nvim.desktop";
        "text/x-csharp" = "nvim.desktop";
        "text/x-python" = "nvim.desktop";
        "inode/directory" = "yazi.desktop";

        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
        "application/msword" = "writer.desktop";
      };
    };

    terminal-exec = {
      enable = true;
      settings = rec {
        Hyprland = [
          "com.mitchellh.ghostty.desktop"
        ];
        default = Hyprland;
      };
    };

    portal = {
      enable = true;
      # wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
        # pkgs.xdg-desktop-portal-hyprland
      ];
      config = rec {
        hyprland = {
          default = [ "hyprland" ];
          # "org.freedesktop.impl.portal.ScreenCast" = [
          #   "gnome"
          # ];
        };
        sway = {
          default = [ "gtk" "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        };
        river = sway;
        common = sway;
      };

      xdgOpenUsePortal = true;
    };
  };
}
