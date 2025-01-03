{
  config,
  pkgs,
  environment,
  ...
}: {
  systemd.timers."sync-blog" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1h";
      OnUnitActiveSec = "1h";
      Unit = "sync-blog.service";
    };
  };

  systemd.services."sync-blog" = {
    description = "Obsidian Sync to Github";
    path = with pkgs; [bash rsync git openssh];
    environment = config.environment.variables;
    script = "bash $NIX_CONFIG_HOME/scripts/sync-blog.sh";
    serviceConfig = {
      Type = "oneshot";
      User = "smissingham";
    };
  };
}
