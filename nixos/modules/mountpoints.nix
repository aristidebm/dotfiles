{pkgs, ...}:

{
   fileSystems."/home" = {
       device = "/dev/disk/by-uuid/26a9e900-6210-4982-a488-cf687c5f6162";
       fsType = "ext4";
   };
}
