# ----- PACKAGES TO INSTALL ON ALL (DARWIN + NIXOS) SYSTEMS -----#
{ pkgs, mainUser, ... }:
{
  #----- Applications in User Space -----#
  home-manager.users.${mainUser.username}.home.packages = with pkgs; [ raycast ];
  #----- Applications in System Space -----#
  environment.systemPackages = with pkgs; [

  ];
}
