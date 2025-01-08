{
  # Import all your configuration modules here
  imports = [ ./bufferline.nix ];

  colorschemes.catppuccin = {
    enable = true;
    settings.flavour = "mocha";
  };

  plugins = {

    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };
    };

    lualine = {
      enable = true;
      #settings.options.theme = "catpuccin_mocha"; # implemented with stylix
    };

    oil.enable = true;
    treesitter.enable = true;
    luasnip.enable = true;

    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        nixd.autostart = true;
      };
    };

    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
  };
}
