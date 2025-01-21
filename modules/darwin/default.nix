# ----- DEFAULTS TO APPLY ONLY ON DARWIN SYSTEMS -----#
{ mainUser, pkgs, ... }:
{

  imports = [
    ./home.nix
    ./packages.nix
  ];

  system = {

    defaults = {

      CustomUserPreferences = {

        "com.apple.screencapture" = {
          location = "~/Documents/Screenshots";
          type = "png";
        };

        "com.apple.controlcenter" = {
          "NSStatusItem Visible Battery" = true;
          "NSStatusItem Visible BentoBox" = true;
          "NSStatusItem Visible Clock" = true;
          "NSStatusItem Visible DoNotDisturb" = false;
          "NSStatusItem Visible Item-0" = false;
          "NSStatusItem Visible Item-1" = false;
          "NSStatusItem Visible Item-2" = false;
          "NSStatusItem Visible Item-3" = false;
          "NSStatusItem Visible Item-4" = false;
          "NSStatusItem Visible Item-5" = false;
          "NSStatusItem Visible NowPlaying" = false;
          "NSStatusItem Visible Sound" = true;
          "NSStatusItem Visible WiFi" = false;
        };
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    # Following line should allow us to avoid a logout/login cycle
    activationScripts.postUserActivation.text = ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

}
