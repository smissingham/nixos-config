{
  description = "My Nix Config";

  inputs = {

    # nix
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix (secrets manager)
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # alacritty
    alacritty-theme = {
      url = "github:alexghr/alacritty-theme.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # stylix
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      plasma-manager,
      ...
    }:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

      overlays = [
        inputs.agenix.overlays.default
        inputs.alacritty-theme.overlays.default
      ];

      nixosModules = import ./modules/nixos;
      homeManagerModules = (import ./modules/home-manager);
      legacyPackages = forAllSystems (
        system:
        import nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
            packageOverrides = pkgs: {
              filen-desktop = pkgs.callPackage ./packages/filen-desktop.nix { };
            };
          };
        }
      );

      # ----- MAIN USER SETTINGS ----- #
      mainUser = {
        username = "smissingham";
        name = "Sean Missingham";
        email = "sean@missingham.com";
      };
    in
    {
      inherit legacyPackages nixosModules homeManagerModules;

      nixosConfigurations =
        let
          defaultModules = [
            inputs.home-manager.nixosModules.default
            inputs.agenix.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];
          specialArgs = {
            inherit
              inputs
              outputs
              overlays
              mainUser
              plasma-manager
              ;
          };
        in
        {
          # My home desktop / server
          coeus = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = defaultModules ++ [

              # custom toggleable modules
              ./modules

              # system config base module
              ./hosts/coeus/configuration.nix

              # user profiles
              ./profiles/mainUser.nix
            ];
          };

          # kvm sandbox
          thalos = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = defaultModules ++ [

              # custom toggleable modules
              ./modules

              # system config base module
              ./hosts/thalos/configuration.nix

              # user profiles
              ./profiles/mainUser.nix
            ];
          };

        };
    };
}
