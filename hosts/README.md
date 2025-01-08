## Installing & Adding New Hosts

- Install NixOS to new host
    - Use [GNOME based graphical installer ISO](https://nixos.org/download/)
        - Even if you want another DE, you can choose during install. GNOME installer is more stable.
    - Set up default user, password etc.
    - Allow unfree software is recommended
    - Note, choosing no desktop environment (minimal install) pollutes your config less, and can always be turned on with modules at the next step
- After install, `cd ~/Documents; 
    - `cd ~/Documents`
    - `git clone --depth=1 https://github.com/smissingham/nixos-config`
    - 'cd nixos-config`
    - Update the user settings in flake.nix if desired
    - `cp -ra` # TODO: Finish
    - `mv configuration.nix default.nix` # TODO: Finish
    - `git add .` **!IMPORTANT!** Flake build MUST see the staged files!!!
    - Add a host configuration block to flake.nix that points to the copied config
    - `sudo nixos-rebuild switch --flake .#HOSTNAME --show-trace`
- Reboot, and from now on, manage your config from that folder. 
    - Be sure to check out shell aliases for simplified rebuild commands

## Reinstalling Existing Hosts

- TODO: Write... (tldr, set up install scripts inside host dir)