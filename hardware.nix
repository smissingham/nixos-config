{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # Data Drive Mount
  fileSystems."/home/smissingham/a" = {
    device = "/dev/nvme2n1p1";
    fsType = "btrfs";
    options = [
      # If you don't have this options attribute, it'll default to "defaults"
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      #"nofail" # Prevent system from failing if this drive doesn't mount
    ];
  };
}
