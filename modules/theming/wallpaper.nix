{ config, pkgs, lib, ... }:

{
  # Install necessary packages
  home.packages = with pkgs; [
    swww            # Wallpaper setter
    pywal           # Color scheme generator
    python3Packages.pywalfox  # Firefox theme integration
    # Adding some dependencies your script might need
    swaybg          # Fallback wallpaper setter
  ];

  # Wallpaper initialization script
  xdg.configFile."hypr/scripts/init-wallpaper.sh" = {
    text = ''
      #!/bin/bash

      # Properly set PATH without referencing an undefined variable
      PATH="$PATH:$HOME/.local/bin"
      
      # Make sure we have the cache directory
      mkdir -p "$HOME/.cache/wal"
      
      # Initialize swww
      swww init

      if [ -e "$HOME/.cache/wal/colors" ]; then
          # Restore pywal colors
          ${pkgs.pywal}/bin/wal -R --cols16
          echo "Cached colors exist. Using existing colors."
          
          # Get saved wallpaper path
          if [ -e "$HOME/.cache/mywall" ]; then
              WALL=$(cat $HOME/.cache/mywall)
              
              # Set wallpaper using swww
              ${pkgs.swww}/bin/swww img "$WALL" --transition-type grow --transition-pos "$(hyprctl cursorpos)" --transition-duration 2
              
              echo "Successfully restored wallpaper: $WALL"
          else
              # Default wallpaper if no cache exists
              DEFAULT_WALL="$HOME/.config/wallpapers/catppuccin.png"
              ${pkgs.swww}/bin/swww img "$DEFAULT_WALL" --transition-type grow --transition-pos "$(hyprctl cursorpos)" --transition-duration 2
              echo "$DEFAULT_WALL" > "$HOME/.cache/mywall"
              echo "No cached wallpaper. Set default wallpaper."
          fi
      else
          # No cached colors, generate from default wallpaper
          DEFAULT_WALL="$HOME/.config/wallpapers/catppuccin.png"
          ${pkgs.pywal}/bin/wal -i "$DEFAULT_WALL" --cols16 -n
          ${pkgs.swww}/bin/swww img "$DEFAULT_WALL" --transition-type grow --transition-pos "$(hyprctl cursorpos)" --transition-duration 2
          echo "$DEFAULT_WALL" > "$HOME/.cache/mywall"
          echo "Generated new colors from default wallpaper."
      fi

      # Update Firefox theme if pywalfox is installed
      if command -v pywalfox &> /dev/null; then
          pywalfox update
      fi
      
      # Update other themes if scripts exist
      if [ -f "$HOME/.config/cava/scripts/update-colors.sh" ]; then
          . $HOME/.config/cava/scripts/update-colors.sh
      fi
      
      if [ -f "$HOME/.config/spicetify/Themes/Pywal/update-colors.sh" ]; then
          . $HOME/.config/spicetify/Themes/Pywal/update-colors.sh
      fi
    '';
    executable = true;
  };

  # Wallpaper picker script
  xdg.configFile."hypr/scripts/wallpaper-picker.sh" = {
    text = ''
      #!/bin/bash
      
      # Properly set PATH without referencing an undefined variable
      PATH="$PATH:$HOME/.local/bin"
      
      # Directory containing wallpapers
      WALLPAPER_DIR="$HOME/.config/wallpapers"
      
      # Create directory if it doesn't exist
      mkdir -p "$WALLPAPER_DIR"
      
      # Use wofi as a selector
      selected=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | sort | wofi --dmenu --prompt "Select wallpaper:")
      
      # If a wallpaper was selected
      if [ -n "$selected" ]; then
          # Generate colors with pywal
          ${pkgs.pywal}/bin/wal -i "$selected" --cols16 -n
          
          # Save the selected wallpaper path for persistence
          echo "$selected" > "$HOME/.cache/mywall"
          
          # Set the wallpaper using swww with animation
          ${pkgs.swww}/bin/swww img "$selected" --transition-type grow --transition-pos "$(hyprctl cursorpos)" --transition-duration 2
          
          # Update Firefox theme if pywalfox is installed
          if command -v pywalfox &> /dev/null; then
              pywalfox update
          fi
          
          # Update other themes if scripts exist
          if [ -f "$HOME/.config/cava/scripts/update-colors.sh" ]; then
              . $HOME/.config/cava/scripts/update-colors.sh
          fi
          
          if [ -f "$HOME/.config/spicetify/Themes/Pywal/update-colors.sh" ]; then
              . $HOME/.config/spicetify/Themes/Pywal/update-colors.sh
          fi
          
          notify-send "Wallpaper & Theme Changed" "Applied $(basename "$selected")" --icon="$selected"
      fi
    '';
    executable = true;
  };

  # Create directories for additional theme scripts
  home.activation.createThemeScriptDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.config/cava/scripts
    mkdir -p $HOME/.config/spicetify/Themes/Pywal
  '';

  # Cava colors update script
  xdg.configFile."cava/scripts/update-colors.sh" = {
    text = ''
      #!/bin/bash
      
      # Get colors from pywal
      source "$HOME/.cache/wal/colors.sh"
      
      # Create cava config directory if it doesn't exist
      mkdir -p "$HOME/.config/cava"
      
      # Generate cava config with pywal colors
      cat > "$HOME/.config/cava/config" << CAVACFG
      [color]
      gradient = 1
      gradient_count = 8
      gradient_color_1 = '$color1'
      gradient_color_2 = '$color2'
      gradient_color_3 = '$color3'
      gradient_color_4 = '$color4'
      gradient_color_5 = '$color5'
      gradient_color_6 = '$color6'
      gradient_color_7 = '$color7'
      gradient_color_8 = '$color8'
      CAVACFG
      
      echo "Updated cava colors"
    '';
    executable = true;
  };

  # Create a placeholder for spicetify
  xdg.configFile."spicetify/Themes/Pywal/update-colors.sh" = {
    text = ''
      #!/bin/bash
      # Placeholder for spicetify theme updates
      # You can fill this with your actual spicetify theme update script
      echo "Spicetify theme update placeholder"
    '';
    executable = true;
  };

  # Add pywal template for kitty
  xdg.configFile."wal/templates/colors-kitty.conf" = {
    text = ''
      foreground         {foreground}
      background         {background}
      background_opacity 0.95
      cursor             {cursor}
      
      active_tab_foreground     {background}
      active_tab_background     {foreground}
      inactive_tab_foreground   {foreground}
      inactive_tab_background   {background}
      
      active_border_color   {foreground}
      inactive_border_color {background}
      bell_border_color     {color1}
      
      color0       {color0}
      color8       {color8}
      color1       {color1}
      color9       {color9}
      color2       {color2}
      color10      {color10}
      color3       {color3}
      color11      {color11}
      color4       {color4}
      color12      {color12}
      color5       {color5}
      color13      {color13}
      color6       {color6}
      color14      {color14}
      color7       {color7}
      color15      {color15}
    '';
  };

  # Ensure wallpapers directory exists and contains a default wallpaper
  xdg.configFile."wallpapers/.keep".text = "";
  home.activation.setupWallpapers = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create wallpapers directory if it doesn't exist
    mkdir -p $HOME/.config/wallpapers
    
    # Download catppuccin wallpaper if it doesn't exist
    if [ ! -f $HOME/.config/wallpapers/catppuccin.png ]; then
      echo "Downloading default wallpaper..."
      $DRY_RUN_CMD ${pkgs.curl}/bin/curl $VERBOSE_ARG -L -o $HOME/.config/wallpapers/catppuccin.png https://raw.githubusercontent.com/catppuccin/wallpapers/main/minimalistic/catppuccin_gradient.png
    fi
  '';
}
