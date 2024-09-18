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
      ExecStart = "google-drive-ocamlfuse ~/g";
      ExecStop = "fusermount - u ~/g";
      Restart = "always";
      Type = "forking";
    };
    wantedBy = ["multi-user.target"];
    # aliases = [
    #   "google-drive.service"
    # ];
  };
}
