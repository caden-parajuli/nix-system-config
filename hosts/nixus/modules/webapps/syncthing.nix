{...}:
{
  services = {
    syncthing = {
      enable = true;
      user = "syncthing";
      group = "media";
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices = {
          "Ultra" = { id = "N3QPRPC-VJVZODG-GUSGTMX-EZJMHH5-T3MRPXA-MRCOLSG-H3I4O2N-VAXPFA6"; };
        };
        folders = {
          "Transmission" = {
            id = "24fuf-zw4yj";
            path = "/media/syncthing";
            devices = [ "Ultra" ];
          };
        };
        gui = {
          user = "caden";
          password = "$2y$12$kkEefBpVnOVQRdO.EyZ71OD7u5ApIBfkF7vWSOyGLKBhU3tm/PcU.";
          theme = "black";
        };
      };
    };
  };
}
