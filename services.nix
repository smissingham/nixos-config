{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  settings,
  localpkgs,
  ...
}: {
  ## SYSTEM SERVICES

  #services.onedrive.enable = true;

  ## USER SERVICES

  systemd.user.services.rclone-proton-drive = {
    description = "rclone sync proton drive";
    serviceConfig = {
      Type = "oneshot";
      User = "smissingham";
      Group = "users";
      WorkingDirectory = "/home/smissingham/proton-drive";
      ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full cloudsync: /home/smissingham/proton-drive";
    };
    wantedBy = ["multi-user.target"];
  };
}
