{
  mainUser,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./systemd.nix
  ];

  environment.variables = {
    NIX_CONFIG_HOME = "/home/smissingham/Documents/Nix";
  };

  mySystemModules = {
    wm.gnome-xserver.enable = true;
    access.sunshine.enable = true;
    coding.vscodium.enable = true;
  };

  myHomeModules = {
    browsers.floorp.enable = true;
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "virtiofs" ];

  networking.hostName = "thalos";
  time.timeZone = "America/Chicago";

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "smissingham";

  system.stateVersion = "24.11"; # Did you read the docs?
}
