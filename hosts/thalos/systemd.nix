{
  ...
}:
{
  #"mount -t virtiofs _home_smissingham_Documents /home/smissingham/Documents";
  systemd.mounts = [
    {
      description = "Mount host home documents to vm home documents";
      what = "_home_smissingham_Documents";
      where = "/home/smissingham/Documents";
      type = "virtiofs";
      options = "rw";
    }
  ];

  systemd.automounts = [
    {
      description = "Automount for server...";
      where = "/home/smissingham/Documents";
      wantedBy = [ "multi-user.target" ];
    }
  ];

}
