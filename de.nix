{ config, lib, pkgs, ... }:

# NOTE: If NixOS was installed with an ISO that contained Gnome/KDE config, you'll have
# to disable it from /etc/nixos/configuration.nix


{
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # GNOME config
    
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;


# # KDE config
#     services.xserver.enable = true;
#     services.displayManager.sddm.enable = true;
#     services.desktopManager.plasma6.enable = true;
#     services.displayManager.defaultSession = "plasma";

}