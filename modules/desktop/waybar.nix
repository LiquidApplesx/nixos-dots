{ config, pkgs, ... }:

{
  # Waybar configuration
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
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

  # Make sure waybar is installed
  home.packages = with pkgs; [
    waybar
  ];
}
