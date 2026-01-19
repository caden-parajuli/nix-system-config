{
  inputs,
  pkgs,
  yazi,
  ...
}:
{
  programs.yazi = {
    enable = true;
    package = yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;

    plugins = {
      git = "${inputs.yazi-rs}/git.yazi";
      glow = "${inputs.yazi-glow}";
      what-size = "${inputs.yazi-what-size}";
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
            on = [ "." "s" ];
            run = "plugin what-size";
            desc = "Calc size of selection or cwd";
          }
        ];
      };
    };
  };
}
