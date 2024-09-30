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

  services.onedrive.enable = true;

  ## USER SERVICES

  systemd.user.services.google-drive = {
    enable = true;
    after = [
      "network.target"
    ];
    serviceConfig = {
      ExecStart = "google-drive-ocamlfuse /home/smissingham/g";
      ExecStop = "fusermount - u /home/smissingham/g";
      Restart = "always";
      Type = "forking";
    };
    wantedBy = ["multi-user.target"];
    # aliases = [
    #   "google-drive.service"
    # ];
  };
}
