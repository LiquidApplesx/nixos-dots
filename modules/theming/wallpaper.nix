{ config, pkgs, lib, ... }:

{
  # Install necessary packages
  home.packages = with pkgs; [
    swww            # Wallpaper setter
    pywal           # Color scheme generator
    pywalfox-native  # Firefox theme integration
    # Adding some dependencies your script might need
    swaybg          # Fallback wallpaper setter
    libnotify       # For notify-send
    findutils       # For find command
    wofi            # For wallpaper selection
  ];

  # Wallpaper initialization script
  home.file.".config/hypr/scripts/init-wallpaper.sh" = {
    text = ''
      #!${pkgs.bash}/bin/bash

      # Properly set PATH without referencing an undefined variable
      PATH="$PATH:$HOME/.local/bin"
      
      # Make sure we have the cache directory
      mkdir -p "$HOME/.cache/wal"
      
      # Initialize swww
      ${pkgs.swww}/bin/swww init

      if [ -e "$HOME/.cache/wal/colors" ]; then
          # Restore pywal colors
          ${pkgs.pywal}/bin/wal -R --cols16
          echo "Cached colors exist. Using existing colors."
          
          # Get saved wallpaper path
          if [ -e "$HOME/.cache/mywall" ]; then
              WALL=$(cat $HOME/.cache/mywall)
              
              # Set wallpaper using swww
              ${pkgs.swww}/bin/swww img "$WALL" --transition-type grow --transition-pos "$(${pkgs.hyprland}/bin/hyprctl cursorpos)" --transition-duration 2
              
              echo "Successfully restored wallpaper: $WALL"
          else
              # Default wallpaper if no cache exists
              DEFAULT_WALL="$HOME/.config/wallpapers/catppuccin.png"
              ${pkgs.swww}/bin/swww img "$DEFAULT_WALL" --transition-type grow --transition-pos "$(${pkgs.hyprland}/bin/hyprctl cursorpos)" --transition-duration 2
              echo "$DEFAULT_WALL" > "$HOME/.cache/mywall"
              echo "No cached wallpaper. Set default wallpaper."
          fi
      else
          # No cached colors, generate from default wallpaper
          DEFAULT_WALL="$HOME/.config/wallpapers/catppuccin.png"
          ${pkgs.pywal}/bin/wal -i "$DEFAULT_WALL" --cols16 -n
          ${pkgs.swww}/bin/swww img "$DEFAULT_WALL" --transition-type grow --transition-pos "$(${pkgs.hyprland}/bin/hyprctl cursorpos)" --transition-duration 2
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
  home.file.".config/hypr/scripts/wallpaper-picker.sh" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      
      # Enable logging for debugging
      exec &> /tmp/wallpaper-picker.log
      echo "Script started at $(date)"
      
      # Properly set PATH without referencing an undefined variable
      PATH="$PATH:$HOME/.local/bin"
      
      # Directory containing wallpapers
      WALLPAPER_DIR="$HOME/.config/wallpapers"
      
      # Create directory if it doesn't exist
      mkdir -p "$WALLPAPER_DIR"
      
      # Count wallpapers for debugging
      WALLPAPER_COUNT=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | wc -l)
      echo "Found $WALLPAPER_COUNT wallpapers in $WALLPAPER_DIR"
      
      # Use wofi as a selector
      echo "Launching wofi..."
      selected=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | sort | ${pkgs.wofi}/bin/wofi --dmenu --prompt "Select wallpaper:")
      echo "Wofi returned: $selected"
      
      # If a wallpaper was selected
      if [ -n "$selected" ]; then
          echo "Processing selected wallpaper: $selected"
          
          # Generate colors with pywal
          ${pkgs.pywal}/bin/wal -i "$selected" --cols16 -n
          echo "Generated colors with pywal"
          
          # Save the selected wallpaper path for persistence
          echo "$selected" > "$HOME/.cache/mywall"
          
          # Set the wallpaper using swww with animation
          echo "Setting wallpaper with swww"
          ${pkgs.swww}/bin/swww img "$selected" --transition-type grow --transition-pos "$(${pkgs.hyprland}/bin/hyprctl cursorpos)" --transition-duration 2
          
          # Update Firefox theme if pywalfox is installed
          if command -v pywalfox &> /dev/null; then
              echo "Updating pywalfox"
              pywalfox update
          fi
          
          # Update other themes if scripts exist
          if [ -f "$HOME/.config/cava/scripts/update-colors.sh" ]; then
              echo "Updating cava colors"
              . $HOME/.config/cava/scripts/update-colors.sh
          fi
          
          if [ -f "$HOME/.config/spicetify/Themes/Pywal/update-colors.sh" ]; then
              echo "Updating spicetify"
              . $HOME/.config/spicetify/Themes/Pywal/update-colors.sh
          fi
          
          ${pkgs.libnotify}/bin/notify-send "Wallpaper & Theme Changed" "Applied $(basename "$selected")" --icon="$selected"
          echo "Script completed successfully"
      else
          echo "No wallpaper selected or wofi was closed"
          ${pkgs.libnotify}/bin/notify-send "Wallpaper Selection" "No wallpaper selected" --icon=dialog-information
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
  home.file.".config/cava/scripts/update-colors.sh" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      
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
  home.file.".config/spicetify/Themes/Pywal/update-colors.sh" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      
      # Get colors from pywal
      source "$HOME/.cache/wal/colors.sh"
      
      # Check if spicetify is installed
      if ! command -v spicetify &> /dev/null; then
          echo "Spicetify not found. Skipping theme update."
          exit 0
      fi
      
      # Ensure the Pywal theme directory exists
      mkdir -p "$HOME/.config/spicetify/Themes/Pywal"
      
      # Create color.ini with pywal colors
      cat > "$HOME/.config/spicetify/Themes/Pywal/color.ini" << EOF
      [Base]
      main_fg                               = ''${foreground}
      secondary_fg                          = ''${color7}
      main_bg                               = ''${background}
      sidebar_and_player_bg                 = ''${background}
      cover_overlay_and_shadow              = 000000
      indicator_fg_and_button_bg            = ''${color5}
      pressing_fg                           = ''${color4}
      slider_bg                             = ''${color0}
      sidebar_indicator_and_hover_button_bg = ''${color2}
      scrollbar_fg_and_selected_row_bg      = ''${color1}
      pressing_button_fg                    = ''${color6}
      pressing_button_bg                    = ''${color3}
      selected_button                       = ''${color2}
      miscellaneous_bg                      = ''${color0}
      miscellaneous_hover_bg                = ''${color7}
      preserve_1                            = FFFFFF
      EOF
      
      # Apply the theme if spicetify is already configured
      if spicetify config current_theme &> /dev/null; then
          spicetify update
          echo "Updated Spicetify theme with pywal colors"
      else
          echo "Spicetify theme created but not applied (run 'spicetify apply' manually)"
      fi
    '';
    executable = true;
  };

  # Add pywal template for kitty
  home.file.".config/wal/templates/colors-kitty.conf" = {
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
      
      # URL styles
      url_color {color4}
      url_style single
      
      # Cursor styles
      cursor_shape block
      cursor_blink_interval 0.5
      
      # Window padding
      window_padding_width 10
      
      # Tab bar styles
      tab_bar_edge top
      tab_bar_style fade
      tab_fade 0 1 1 1
      
      # Font settings
      font_family      JetBrainsMono Nerd Font
      bold_font        JetBrainsMono Nerd Font Bold
      italic_font      JetBrainsMono Nerd Font Italic
      bold_italic_font JetBrainsMono Nerd Font Bold Italic
      font_size 12.0
    '';
  };

  # Ensure wallpapers directory exists and contains a default wallpaper
  home.file.".config/wallpapers/.keep".text = "";
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
