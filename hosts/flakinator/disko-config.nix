let
  rawdisk1 = "/dev/nvme0n1";
in
{
  disko.devices = {
    disk = {
      root = {
        device = "${rawdisk1}" ;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "EFI";
              name = "ESP";
              size = "1024M";
              type = "EF00" ;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              label = "swap";
              size = "32G"; # SWAP - Do not Delete this comment
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
