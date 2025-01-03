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

    programs.zsh.enable = true;
    programs.steam.enable = true; # sadly, steam has to be installed via global modules, other options don't work

    environment.pathsToLink = ["/share/zsh"]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enableCompletion
    fonts.packages = with pkgs; [nerdfonts];

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
      backupFileExtension = "hm-bak";

      users.smissingham = {pkgs, ...}: {
        imports = [
          (import "${plasma-manager}/modules")
        ];
        home.stateVersion = "24.11";
        services.home-manager.autoUpgrade.enable = config.system.autoUpgrade.enable;
        services.home-manager.autoUpgrade.frequency = config.system.autoUpgrade.dates;

        home.packages = with pkgs; [
          # WEB BROWSING
          floorp
          #chromium
          #microsoft-edge
          kdePackages.plasma-browser-integration
          #kdePackages.discover flathub browser

          # MEDIA & ENTERTAINMENT
          spotify
          xboxdrv # xbox controller driver

          # COMMUNICATIONS
          telegram-desktop
          discord

          # OFFICE
          libreoffice
          obsidian
          thunderbird
          filen-desktop

          # DEV TOOLS
          alacritty
          kdePackages.kate
          jetbrains-toolbox
          vscode
          gitkraken
          bruno
          podman-desktop

          # WORK APPS
          teams-for-linux

          # TERMINAL STUFF
          neovim
          tmux
          fzf
          eza
          tldr
          xclip
          zoxide
        ];

        programs.git = {
          enable = true;
          userName = "Sean Missingham";
          userEmail = "sean@missingham.com";
        };

        programs.zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          shellAliases = {
            z = "zoxide";
            ls = "eza";
            ll = "eza -l";
            la = "eza -la";
            vim = "nvim";
            vi = "nvim";
            clip = "xclip -selection clipboard";
            nxrebuild = "bash $NIX_CONFIG_HOME/scripts/nxrebuild.sh";
            nxshell = "nix-shell -p $1";
            nxbuild = "nix-build -E 'with import <nixpkgs> {}; callPackage '\"$1\"' {}' --show-trace";
            nxgc = "nix-collect-garbage --delete-old";
          };

          history = {
            size = 10000;
            #path = "${config.xdg.dataHome}/zsh/history";
          };

          oh-my-zsh = {
            enable = true;
            #theme = "robbyrussell";
          };

          initExtra = "source ~/.p10k.zsh";

          plugins = [
            {
              name = "powerlevel10k";
              src = pkgs.zsh-powerlevel10k;
              file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
          ];
        };

        programs.plasma = {
          enable = true;

          workspace = {
            lookAndFeel = "org.kde.breezedark.desktop";
            theme = "breeze-dark";
            colorScheme = "BreezeDark";
          };

          hotkeys.commands."launch-alacritty" = {
            name = "Launch Alacritty";
            key = "Ctrl+`";
            command = "alacritty";
          };

          hotkeys.commands."launch-system-monitor" = {
            name = "Launch System Monitor";
            key = "Ctrl+Shift+Escape";
            command = "plasma-systemmonitor";
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
                      "applications:jetbrains-toolbox.desktop"
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
