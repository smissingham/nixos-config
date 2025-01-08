{
  ...
}:
{
  imports = [
    ./hardware.nix
    ./systemd.nix
  ];

  environment.variables = {
    NIX_CONFIG_HOME = "/mnt/coeus/nixos";
  };

  myModules = {
    access.sunshine.enable = true;
    entertainment.gaming.enable = true;
    wm.plasma6.enable = true;
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "thalos";
  time.timeZone = "America/Chicago";

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "smissingham";

  system.stateVersion = "24.11"; # Did you read the docs?
}
