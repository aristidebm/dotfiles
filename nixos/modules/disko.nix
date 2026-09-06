# Inspiration from
# https://github.com/nix-community/disko/tree/ff8702b4de27f72b4c78573dfb89ec74e36abdf1/example
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {

            boot = {
              name = "boot";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              name = "swap";
              size = "5G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true; # resume from hiberation from this device
              };
            };

            root = {
              name = "root";
              size = "230G";
              content = {
                type = "filesystem";
                format = "ext4"; # Feel free to change to btrfs if desired
                mountpoint = "/";
              };
            };

            home = {
              name = "home";
              size = "100%";
              content = {
                type = "none"; # "none" prevents Disko from creating a filesystem or wiping data
              };
            };
          };
        };
      };
    };
  };
}
