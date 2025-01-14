{
  inputs,
  pkgs,
  yazi,
  zig,
  ...
}:

rec {
  catppuccin = {
    enable = true;

    gtk.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
    waybar.enable = false;
  };

  programs = {
    home-manager.enable = true;

    # neovim = {
    #   enable = true;
    #   package = pkgs.neovim-unwrapped;
    #   defaultEditor = true;
    #   withNodeJs = true;
    #   withPython3 = true;
    #   extraLuaPackages = ps: [ ps.luautf8 ];
    #   extraPackages = [ ];
    # };

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
        firefox = "firefox-nightly";
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
          name = "sponge";
          src = pkgs.fishPlugins.sponge.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
      ];
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
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      package = pkgs.catppuccin-kvantum;
      name = "kvantum";
    };
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
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${homeDirectory}/.steam/root/compatibilitytools.d";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };

    pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 16;
    };

    packages = with pkgs; [
      #
      # Dev
      #

      # General
      git
      gnumake
      tree-sitter
      vscode-langservers-extracted
      stow

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

      # Nim
      nim
      nimlangserver

      # Zig
      zig.packages.${pkgs.system}.master

      # Haskell
      haskellPackages.haskell-language-server
      haskellPackages.stack
      haskell.compiler.ghc96

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
      appflowy

      #
      # GUI Apps
      #

      alacritty
      foot
      rofi-wayland
      tauon
      inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
      xarchiver
      zathura

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

      #
      # Desktop tools
      #

      # For Hyprland
      xdg-desktop-portal-hyprland
      hyprpicker
      hyprsunset
      wl-clipboard-rs
      hyprls
      # Screenshot
      grim
      slurp
      # Status
      avizo
      waybar
      swaynotificationcenter

      # Control
      playerctl
      wdisplays
      networkmanagerapplet
      pavucontrol

      # Theming
      libsForQt5.qt5ct
      catppuccin-qt5ct
      libsForQt5.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum

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

      yazi.packages.${pkgs.system}.default
      fish
      parted
      bat
      psmisc
      ripgrep
      ripgrep-all
      ran
      jq
      grc
      yt-dlp
      comma
      # zoxide
      tlrc
      git-open
      xxh
      sshs

      # Networking
      dig
      inetutils

      # Fonts
      nerd-fonts.fira-code

      # Misc
      xdg-utils
      ventoy
    ];
  };
  systemd.user.sessionVariables = home.sessionVariables;

}
