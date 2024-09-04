{
  config,
  lib,
  pkgs,
  ...
}:
# NOTE: If NixOS was installed with an ISO that contained Gnome/KDE config, you'll have
# to disable it from /etc/nixos/configuration.nix
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # # GNOME config
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # KDE config
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  environment.systemPackages = [
    # Application software downloader
    # Note, have to add the flathub repository after flatpak first install to get this working.
    # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    pkgs.kdePackages.discover

    #pkgs.kdePackages.kmail
    #pkgs.kdePackages.kmail-account-wizard
    pkgs.kdePackages.partitionmanager
  ];
}
