{pkgs, ...}:
{
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    config = pkgs.lib.mkAfter ''
      Section "Device"
          Identifier  "nvidiagpu"
          Driver      "nvidia"
      EndSection
      
      Section "Screen"
          Identifier  "nvidiascreen"
          Device      "nvidiagpu"
          Option      "ConnectedMonitor" "DFP-1"
      EndSection
    '';
    # config = pkgs.lib.mkAfter ''
    #   Section "ServerLayout"
    #   Identifier "TwinLayout"
    #   Screen 0 "metaScreen" 0 0
    #   EndSection
    #   
    #   Section "Monitor"
    #   Identifier "Monitor0"
    #   Option "Enable" "true"
    #   EndSection
    #   
    #   Section "Device"
    #   Identifier "Card0"
    #   Driver "nvidia"
    #   VendorName "NVIDIA Corporation"
    #   Option "TwinView"
    #   Option "MetaModes" "1920x1080"
    #   Option "ConnectedMonitor" "DP-0"
    #   Option "ModeValidation" "NoDFPNativeResolutionCheck,NoVirtualSizeCheck,NoMaxPClkCheck,NoHorizSyncCheck,NoVertRefreshCheck,NoWidthAlignmentCheck"
    #   EndSection
    #   
    #   Section "Screen"
    #   Identifier "metaScreen"
    #   Device "Card0"
    #   Monitor "Monitor0"
    #   DefaultDepth 24
    #   Option "TwinView" "True"
    #   SubSection "Display"
    #   Modes "1920x1080"
    #   EndSubSection
    #   EndSection
    # '';
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      sunshine_name = "nixus";
      port = 47989;
      capture = "kms";
      adapter_name = "/dev/dri/renderD128";
    };
  };
}
