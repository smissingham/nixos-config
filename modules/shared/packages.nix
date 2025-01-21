# ----- PACKAGES TO INSTALL ON ALL (DARWIN + NIXOS) SYSTEMS -----#
{
  pkgs,
  mainUser,
  ...
}:
{
  #----- Fonts Available to System -----#
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Ubuntu"
        "UbuntuMono"
      ];
    })
  ];
  #----- Applications in User Space -----#
  home-manager.users.${mainUser.username}.home.packages = with pkgs; [
    alacritty
    floorp
  ];
  #----- Applications in System Space -----#
  environment.systemPackages = with pkgs; [
    pciutils
    #usbutils
    findutils

    eza
    fzf
    tldr
    xclip
    zoxide

    nixfmt-rfc-style
  ];
}
