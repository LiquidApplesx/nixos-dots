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
      # Catppuccin Mocha Theme
      foreground           #CDD6F4
      background           #1E1E2E
      selection_foreground #1E1E2E
      selection_background #F5E0DC
      
      # Cursor colors
      cursor            #F5E0DC
      cursor_text_color #1E1E2E
      
      # URL underline color when hovering with mouse
      url_color #F5E0DC
      
      # kitty window border colors
      active_border_color   #B4BEFE
      inactive_border_color #6C7086
      bell_border_color     #F9E2AF
      
      # OS Window titlebar colors
      wayland_titlebar_color system
      macos_titlebar_color system
      
      # Tab bar colors
      active_tab_foreground   #11111B
      active_tab_background   #CBA6F7
      inactive_tab_foreground #CDD6F4
      inactive_tab_background #181825
      tab_bar_background      #11111B
      
      # The 16 terminal colors
      
      # black
      color0 #45475A
      color8 #585B70
      
      # red
      color1 #F38BA8
      color9 #F38BA8
      
      # green
      color2  #A6E3A1
      color10 #A6E3A1
      
      # yellow
      color3  #F9E2AF
      color11 #F9E2AF
      
      # blue
      color4  #89B4FA
      color12 #89B4FA
      
      # magenta
      color5  #F5C2E7
      color13 #F5C2E7
      
      # cyan
      color6  #94E2D5
      color14 #94E2D5
      
      # white
      color7  #BAC2DE
      color15 #A6ADC8
    '';
  };

  # Fonts
  fonts.fontconfig.enable = true;
}
