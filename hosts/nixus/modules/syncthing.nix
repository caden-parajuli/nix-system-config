{...}:
{
  services = {
    syncthing = {
      enable = true;
      user = "syncthing";
      group = "media";
      guiAddress = "0.0.0.0:8384";
      settings.gui = {
        user = "caden";
        password = "$2y$12$kkEefBpVnOVQRdO.EyZ71OD7u5ApIBfkF7vWSOyGLKBhU3tm/PcU.";
        theme = "black";
      };
    };
  };
}
