{
  config,
  lib,
  pkgs,
  mainUser,
  ...
}:
let
  shellAliases = {
    "~~" = "~/Documents";
    nv = "nix run ~/Documents/NixOS/flakes/nixvim# -- $1";
    clip = "xclip -selection clipboard";
    nxfmt = "find $NIX_CONFIG_HOME -name '*.nix' -exec nixfmt {} \\;";
    nxrb = "nxfmt; git add .; sudo nixos-rebuild $1 --flake $NIX_CONFIG_HOME#$(hostname) --show-trace";
    nxrbs = "nxrb switch";
    nxrbb = "nxrb build; rm -rf $NIX_CONFIG_HOME/result;";
    nxcommit = "nxfmt; git add $NIX_CONFIG_HOME; git commit $NIX_CONFIG_HOME -m \"$(nixos-rebuild list-generations | grep current)\";";
    nxgc = "nix-collect-garbage --delete-old";
    nxshell = "nix-shell -p $1";

    # TODO: Staging Area. Once happy this is mature, move it up among the rest
    nxbuild = "nix-build -E 'with import <nixpkgs> {}; callPackage '\"$1\"' {}' --show-trace";

    # TODO: Keep Empty. Temp aliases for currently common activities that shouldnt stay common

  };
in
{

  programs.git.enable = true;
  programs.firefox.enable = lib.mkForce false;
  programs.zsh.enable = true;
  fonts.packages = [ pkgs.nerdfonts ];

  users.users.${mainUser.username} = {
    isNormalUser = true;
    description = mainUser.name;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
            #esc = "capslock";
          };
        };
      };
    };
  };

  home-manager = {

    # Allow unfree packages
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    users.${mainUser.username} =
      { pkgs, ... }:
      {
        home.username = mainUser.username;
        home.homeDirectory = "/home/" + mainUser.username;
        home.packages = with pkgs; [
          # TERMINAL
          alacritty
          # tmux # installed with home-manager
          fzf
          eza
          zoxide
          tldr
          xclip
        ];

        xdg.enable = true;
        xdg.userDirs = {
          extraConfig = {
            XDG_GAME_DIR = "${config.home.homeDirectory}/Media/Games";
            XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Media/GameSaves";
          };
        };

        programs.git = {
          userName = mainUser.name;
          userEmail = mainUser.email;
        };

        programs.bash = {
          enable = true;
          enableCompletion = true;
          shellAliases = shellAliases;
        };

        programs.zsh = {
          enable = true;
          enableCompletion = true;
          shellAliases = shellAliases;

          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          history = {
            size = 10000;
          };

          oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
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

        programs.alacritty = {
          enable = true;
          settings = {
            # general.import = [ pkgs.alacritty-theme.catppuccin_mocha ]; # implemented with stylix
            env = {
              TERM = "xterm-256color";
            };
          };
        };

        programs.tmux = {
          enable = true;
          clock24 = true;
          plugins = with pkgs; [
            # tmuxPlugins.catppuccin # implemented with stylix
            tmuxPlugins.better-mouse-mode
            tmuxPlugins.sensible
            tmuxPlugins.vim-tmux-navigator
          ];
          extraConfig = ''
            set -g default-terminal "tmux-256color"
            set -ag terminal-overrides ",xterm-256color:RGB"
          '';
        };

        home.stateVersion = "24.11"; # READ DOCS BEFORE CHANGING
      };
  };
}
