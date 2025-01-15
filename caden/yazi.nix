{
  pkgs,
  yazi,
  ...
}:
let
  yazi-rs = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "600614a9dc59a12a63721738498c5541c7923873";
    hash = "sha256-...";
  };
  glow = pkgs.fetchFromGitHub {
    owner = "Reledia";
    repo = "glow.yazi";
    rev = "5ce76dc92ddd0dcef36e76c0986919fda3db3cf5";
    hash = "sha256-...";
  };
  what-size = pkgs.fetchFromGitHub {
    owner = "pirafrank";
    repo = "what-size.yazi";
    rev = "b23e3a4cf44ce12b81fa6be640524acbd40ad9d3";
    hash = "sha256-...";
  };
in
{
  programs.yazi = {
    enable = true;
    package = yazi.packages.${pkgs.system}.default;

    plugins = {
      git = "${yazi-rs}/git.yazi";
      glow = "${glow}";
      what-size = "${what-size}";
    };

    initLua = ''
      require("git"):setup()
    '';

    settings = {
      yazi = {
        plugin.prepend_previewers = [
          {
            name = "*.md";
            run = "glow";
          }
        ];
        plugin.prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
      };
      keymap = {
        manager.prepend_keymap = [
          {
            on = [
              "."
              "s"
            ];
            run = "plugin what-size";
            desc = "Calc size of selection or cwd";
          }
        ];
      };
    };
  };
}
