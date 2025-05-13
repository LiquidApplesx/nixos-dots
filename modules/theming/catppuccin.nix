{ config, pkgs, ... }:

{
  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Install theming packages
  home.packages = with pkgs; [
    # Theming
    catppuccin-gtk
    papirus-icon-theme

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts-color-emoji
  ];
  
  # Configure kitty with Catppuccin theme
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 11;
      window_padding_width = 8;
      background_opacity = "0.95";
    };
    extraConfig = ''
      # Include colors from pywal
      include ~/.cache/wal/colors-kitty.conf
    '';
  };

  # Fonts
  fonts.fontconfig.enable = true;
}
