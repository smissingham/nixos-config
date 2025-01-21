{ pkgs, lib, ... }:
let
  theme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  sourceUrl = "https://wallpaperswide.com/download/spaceman_art-wallpaper-5120x2160.jpg";
  sourceSha = "f4d9ae0338b7b57dffd335cdcb21552113927ad063c8104c7bbc9dfeacea42f0";
  sourceImage = pkgs.fetchurl {
    url = sourceUrl;
    sha256 = sourceSha;
  };
in
{

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = theme;
    image = sourceImage;

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      };
      sansSerif = {
        name = "Ubuntu Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "Ubuntu" ]; };
      };
      # serif = {
      #   name = "DejaVu Serif";
      #   package = pkgs.dejavu_fonts;
      # };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji-blob-bin;
      };
      sizes = {
        terminal = 12;
        applications = 12;
        popups = 12;
        desktop = 12;
      };
    };
  };
}
