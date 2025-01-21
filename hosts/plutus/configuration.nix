{
  config,
  nixpkgs,
  pkgs,
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ ];
  networking.hostName = "plutus";

  # Use custom location for configuration.nix.
  environment.darwinConfig = "$HOME/.config/nix-darwin/configuration.nix";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
