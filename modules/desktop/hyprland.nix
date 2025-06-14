{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./waybar.nix
  ];

  # Hyprland configuration
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

      # My Programs
      $terminal = kitty
      $browser = firefox-developer-edition

      # Monitor setup
      monitor=eDP-1, 1920x1080@60,auto,1

      # Execute apps at launch
      exec-once = waybar
      exec-once = dunst
      exec-once = swww-daemon && swww restore
      exec-once = sleep 1 && $HOME/.config/hypr/scripts/init-wallpaper.sh
      
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
          
          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }
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
          new_status = master
      }
      
      # Gestures
      gestures {
          workspace_swipe = true
      }
      
      # Window rules
      # windowrule = float, ^(pavucontrol)$
      # windowrule = float, ^(nm-connection-editor)$
      
      # Keybindings
      $mainMod = SUPER
      
      # Basic keybinds
      bind = $mainMod, Return, exec, $terminal
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, wofi --show drun
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod, F, exec, $browser
      bind = $mainMod SHIFT, W, exec, ~/.config/hypr/scripts/wallpaper-picker.sh
      
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

  # Install necessary packages for Hyprland
  home.packages = with pkgs; [
    wofi
    dunst
    wl-clipboard
    kdePackages.dolphin
  ];

  # Configure wofi
  xdg.configFile."wofi/style.css".text = ''
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
}
