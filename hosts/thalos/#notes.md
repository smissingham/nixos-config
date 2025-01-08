# Install Process

- Ensure virtual fs is configured, assuming it's called "_home_smissingham_Documents"
- Boot the GNOME based graphical installer ISO
- Proceed through system installation as desired
- Reboot after install
- Mount the virtual fs
  - `sudo mount -t virtiofs _home_smissingham_Documents /home/smissingham/Documents`
- Update any hardware configs to the /hosts/thalos/hardware.nix, taking care of device ID's
- `cd` to the nix config working directory
- Run the nix rebuild
  - `sudo nixos-rebuild switch --flake ~.#thalos`
- Reboot (just cos)