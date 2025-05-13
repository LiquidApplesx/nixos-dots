{ config, pkgs, inputs, ... }:

{
  # Let Home Manager manage itself
  programs.home-manager.enable = true;
  
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "kari";
  home.homeDirectory = "/home/kari";
  
  # Packages specific to your user environment
  home.packages = with pkgs; [
    # Desktop environment packages
    waybar
    wofi
    dunst
    swww
    wl-clipboard
    dolphin
    
    # Theming
    catppuccin-gtk
    papirus-icon-theme
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];
  
  # Hyprland configuration using the flake input
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    
    extraConfig = ''
      # Catppuccin Mocha Colors
      $rosewater = 0xfff5e0dc
      $flamingo  = 0xfff2cdcd
      $pink      = 0xfff5c2e7
      $mauve     = 0xffcba6f7
      $red       = 0xfff38ba8
      $maroon    = 0xffeba0ac
      $peach     = 0xfffab387
      $yellow    = 0xfff9e2af
      $green     = 0xffa6e3a1
      $teal      = 0xff94e2d5
      $sky       = 0xff89dceb
      $sapphire  = 0xff74c7ec
      $blue      = 0xff89b4fa
      $lavender  = 0xffb4befe
      $text      = 0xffcdd6f4
      $subtext1  = 0xffbac2de
      $subtext0  = 0xffa6adc8
      $overlay2  = 0xff9399b2
      $overlay1  = 0xff7f849c
      $overlay0  = 0xff6c7086
      $surface2  = 0xff585b70
      $surface1  = 0xff45475a
      $surface0  = 0xff313244
      $base      = 0xff1e1e2e
      $mantle    = 0xff181825
      $crust     = 0xff11111b

      # Monitor setup
      monitor=,preferred,auto,1

      # Execute apps at launch
      exec-once = waybar
      exec-once = dunst
      exec-once = swww init && swww img ~/.config/wallpapers/catppuccin.png
      
      # Input config
      input {
          kb_layout = us
          follow_mouse = 1
          sensitivity = 0 # -1.0 - 1.0, 0 means no modification
          
          touchpad {
              natural_scroll = true
          }
      }
      
      # General window layout and colors
      general {
          gaps_in = 5
          gaps_out = 10
          border_size = 2
          col.active_border = $mauve $blue 45deg
          col.inactive_border = $surface0
          
          layout = dwindle
      }
      
      # Decoration settings
      decoration {
          rounding = 8
          
          blur {
              enabled = true
              size = 3
              passes = 1
              new_optimizations = true
          }
          
          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }
      
      # Animation settings
      animations {
          enabled = true
          
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }
      
      # Layout settings
      dwindle {
          pseudotile = true
          preserve_split = true
      }
      
      master {
          new_is_master = true
      }
      
      # Gestures
      gestures {
          workspace_swipe = true
      }
      
      # Window rules
      windowrule = float, ^(pavucontrol)$
      windowrule = float, ^(nm-connection-editor)$
      
      # Keybindings
      $mainMod = SUPER
      
      # Basic keybinds
      bind = $mainMod, Return, exec, kitty
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, dolphin
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, wofi --show drun
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      
      # Move focus
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      
      # Switch workspaces
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10
      
      # Move windows to workspaces
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10
      
      # Mouse bindings
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';
  };
  
  # Waybar with Catppuccin theme
  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: "JetBrains Mono Nerd Font";
        font-size: 12pt;
        border-radius: 0px;
        transition-property: background-color;
        transition-duration: 0.5s;
      }
      
      window#waybar {
        background-color: #1e1e2e;
        color: #cdd6f4;
      }
      
      tooltip {
        background: #1e1e2e;
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: #11111b;
      }
      
      #workspaces button {
        color: #cdd6f4;
        background-color: transparent;
        padding: 5px 10px;
        margin: 3px 3px;
        border-radius: 10px;
      }
      
      #workspaces button.active {
        color: #1e1e2e;
        background-color: #cba6f7;
      }
      
      #workspaces button:hover {
        background-color: #f5c2e7;
        color: #1e1e2e;
      }
      
      #custom-launcher, #clock, #battery, #pulseaudio, #network, #workspaces, #tray {
        background-color: #313244;
        padding: 0px 10px;
        margin: 3px 0px;
      }
      
      #custom-launcher {
        color: #89b4fa;
        margin-left: 5px;
        border-right: 0px;
      }
      
      #tray {
        margin-right: 5px;
        border-radius: 10px;
      }
      
      #clock {
        color: #fab387;
        border-radius: 10px;
      }
      
      #battery {
        color: #a6e3a1;
        border-radius: 10px;
      }
      
      #network {
        color: #f9e2af;
        border-radius: 10px;
      }
      
      #pulseaudio {
        color: #89b4fa;
        border-radius: 10px;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "custom/launcher" "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];
        
        "custom/launcher" = {
          format = " ";
          on-click = "wofi --show drun";
        };
        
        "clock" = {
          format = "{:%H:%M %b %d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = ["" "" "" "" ""];
        };
        
        "network" = {
          format-wifi = " {essid}";
          format-ethernet = " {ipaddr}/{cidr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };
  };
  
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
  
  # Additional config files
  xdg.configFile = {
    # wofi theme
    "wofi/style.css".text = ''
      window {
        margin: 0px;
        border: 2px solid #cba6f7;
        background-color: #1e1e2e;
        border-radius: 15px;
      }
      
      #input {
        margin: 5px;
        border: none;
        color: #cdd6f4;
        background-color: #313244;
        border-radius: 10px;
      }
      
      #inner-box {
        margin: 5px;
        border: none;
        background-color: #1e1e2e;
        border-radius: 10px;
      }
      
      #outer-box {
        margin: 15px;
        border: none;
        background-color: #1e1e2e;
        border-radius: 10px;
      }
      
      #scroll {
        margin: 0px;
        border: none;
      }
      
      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }
      
      #entry:selected {
        background-color: #313244;
        border-radius: 10px;
      }
      
      #entry:selected #text {
        color: #cba6f7;
      }
    '';
    
    # Create directory for wallpapers
    "wallpapers/.keep".text = "";
  };
  
  # Dunst notification daemon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "10x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#f5c2e7";
        font = "JetBrainsMono Nerd Font 11";
        corner_radius = 10;
      };
      
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#cba6f7";
        timeout = 10;
      };
    };
  };
  
  # This value determines the Home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "24.11";
}
