let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
  plasma-manager = builtins.fetchTarball "https://github.com/nix-community/plasma-manager/archive/trunk.tar.gz";
in
  {
    config,
    pkgs,
    ...
  }: {
    imports = [
      (import "${home-manager}/nixos")
    ];

    programs.steam.enable = true; # sadly, steam has to be installed via global modules, other options don't work
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Define system user account (outside of home manager)
    users.users.smissingham = {
      isNormalUser = true;
      description = "smissingham";
      extraGroups = ["networkmanager" "wheel" "podman"];
      shell = pkgs.zsh;
    };

    home-manager = {
      # Allow unfree packages
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [];

      users.smissingham = {pkgs, ...}: {
        home.stateVersion = "24.11";

        home.packages = with pkgs; [
          # WEB BROWSING
          floorp
          #chromium
          #microsoft-edge
          kdePackages.plasma-browser-integration

          # MEDIA & ENTERTAINMENT
          spotify
          xboxdrv # xbox controller driver

          # COMMUNICATIONS
          telegram-desktop
          discord

          # PRODUCTIVITY
          libreoffice
          obsidian

          # DEV TOOLS
          alacritty
          kdePackages.kate
          jetbrains-toolbox
          vscode
          gitkraken
          bruno
          podman-desktop
          neovim

          # WORK APPS
          teams-for-linux
        ];

        programs.git = {
          enable = true;
          userName = "Sean Missingham";
          userEmail = "sean@missingham.com";
        };

        programs.zsh = {
          enableCompletion = true;
          enableAutosuggestions = true;
          syntaxHighlighting.enable = true;

          shellAliases = {
            ll = "ls -l";
            update = "sudo nixos-rebuild switch";
          };

          #history = {
          #  size = 10000;
          #  path = "${config.xdg.dataHome}/zsh/history";
          #};

          oh-my-zsh = {
            enable = true;
            plugins = ["git" "thefuck"];
            theme = "robbyrussell";
          };
        };

        imports = [
          (import "${plasma-manager}/modules")
        ];

        services.home-manager.autoUpgrade.enable = config.system.autoUpgrade.enable;
        services.home-manager.autoUpgrade.frequency = config.system.autoUpgrade.dates;

        programs.plasma = {
          enable = true;

          workspace = {
            lookAndFeel = "org.kde.breezedark.desktop";
            theme = "breeze-dark";
            colorScheme = "BreezeDark";
          };

          hotkeys.commands."launch-konsole" = {
            name = "Launch Konsole";
            key = "Ctrl+`";
            command = "konsole";
          };

          panels = [
            {
              location = "right";
              height = 64;
              floating = false;
              alignment = "center";
              widgets = [
                "org.kde.plasma.panelspacer"
                {
                  iconTasks = {
                    launchers = [
                      "applications:org.kde.dolphin.desktop"
                      "applications:org.kde.konsole.desktop"
                      "applications:floorp.desktop"
                    ];
                  };
                }
                "org.kde.plasma.panelspacer"
                {
                  digitalClock = {
                    date.enable = true;
                    calendar.firstDayOfWeek = "sunday";
                    date = {
                      format = "longDate";
                    };
                    time = {
                      format = "12h";
                      showSeconds = "onlyInTooltip";
                    };
                  };
                }
                {
                  systemTray.items = {
                    shown = [
                      "org.kde.plasma.bluetooth"
                      "org.kde.plasma.networkmanagement"
                      "org.kde.plasma.volume"
                    ];
                  };
                }
                {
                  name = "org.kde.plasma.kickoff";
                  config = {
                    General = {
                      #icon = builtins.fetchurl "custom-launch-icon.svg";
                      alphaSort = true;
                    };
                  };
                }
              ];
              hiding = "none";
            }
          ];
        };
      };
    };
  }
