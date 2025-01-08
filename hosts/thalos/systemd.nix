{
  ...
}:
{
  systemd.user.services.mount-coeus = {
    description = "Mount Coeus Virtual FS";
    wantedBy = [ "default.target" ];
    startLimitBurst = 5;
    startLimitIntervalSec = 500;
    serviceConfig = {
      ExecStart = "mount -t virtiofs _home_smissingham_Documents /home/smissingham/Documents";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
