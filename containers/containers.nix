{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;

  # Use rootless podman. Overall, much nicer than docker for config experience
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;

      # Make the Podman socket available in place of the Docker socket, so Docker tools can find the Podman socket.
      # Users must be in the podman group in order to connect. As with Docker, members of this group can gain root access.
      dockerSocket.enable = true;

      autoPrune.enable = true;
    };
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # podman ui in terminal
    podman-compose # start group of containers for dev
  ];
}
