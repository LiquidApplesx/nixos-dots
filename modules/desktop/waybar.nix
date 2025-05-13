{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    
    # Your Waybar configuration (converted from the JSON)
    settings = {
      mainBar = {
        "margin-top" = 5;
        "modules-center" = [ "hyprland/workspaces" ];
        "modules-left" = [ "clock" "custom/weather" "tray" ];
        "modules-right" = [
          "pulseaudio"
          "pulseaudio#microphone"
          "cpu"
          "memory"
          "temperature"
          "network"
          "custom/power-menu"
        ];
        
        "hyprland/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
          "on-click" = "activate";
          "warp-on-scroll" = false;
          "format" = "{icon}";
          "format-icons" = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
            "9" = "IX";
          };
          "persistent-workspaces" = {
            "*" = 9;
            "DP-1" = 9;
          };
        };
        
        "tray" = {
          "spacing" = 10;
        };
        
        "clock" = {
          "timezone" = "America/New_York";
          "tooltip-format" = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%a %b %d}";
          "format" = "{:%I:%M %p}";
        };
        
        "cpu" = {
          "format" = " {usage}%";
          "tooltip" = false;
        };
        
        "memory" = {
          "interval" = 30;
          "format" = " {}%";
          "format-alt" = " {used:0.1f}G";
          "max-length" = 10;
        };
        
        "temperature" = {
          "critical-threshold" = 80;
          "format" = "{icon} {temperatureC}°C";
          "format-icons" = [ "" "" "" ];
        };
        
        "network" = {
          "format-wifi" = "";
          "format-ethernet" = "󰈀";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };
        
        "pulseaudio" = {
          "format" = "{icon}  {volume}%";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" "" ];
          };
          "on-click" = "pavucontrol";
        };
        
        "pulseaudio#microphone" = {
          "format" = "{format_source}";
          "format-source-muted" = "";
          "format-source" = "";
        };
        
        "custom/weather" = {
          "format" = "{} °";
          "tooltip" = true;
          "interval" = 3600;
          "exec" = "wttrbar --location Raleigh --mph --fahrenheit --date-format %m-%d-%Y --ampm";
          "return-type" = "json";
        };
        
        "custom/power-menu" = {
          "format" = " <span color='#6a92d7'>⏻ </span>";
          "on-click" = "bash ~/.config/waybar/scripts/power-menu/powermenu.sh";
        };
      };
    };
    
    # Your CSS styles
    style = ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: Jetbrains Mono Nerd;
          font-size: 13px;
          font-weight: bold;
      }
      
      /* Catppuccin Macchiato Colors */
      @define-color base   #24273a;
      @define-color mantle #1e2030;
      @define-color crust  #181926;
      
      @define-color text     #cad3f5;
      @define-color subtext0 #a5adcb;
      @define-color subtext1 #b8c0e0;
      
      @define-color surface0 #363a4f;
      @define-color surface1 #494d64;
      @define-color surface2 #5b6078;
      
      @define-color overlay0 #6e738d;
      @define-color overlay1 #8087a2;
      @define-color overlay2 #939ab7;
      
      @define-color blue      #8aadf4;
      @define-color lavender  #b7bdf8;
      @define-color sapphire  #7dc4e4;
      @define-color sky       #91d7e3;
      @define-color teal      #8bd5ca;
      @define-color green     #a6da95;
      @define-color yellow    #eed49f;
      @define-color peach     #f5a97f;
      @define-color maroon    #ee99a0;
      @define-color red       #ed8796;
      @define-color mauve     #c6a0f6;
      @define-color pink      #f5bde6;
      @define-color flamingo  #f0c6c6;
      @define-color rosewater #f4dbd6;

      window#waybar {
          background-color: transparent;
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
      }
      
      window#waybar.hidden {
          opacity: 0.2;
      }
      
      button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
      }
      
      /* you can set a style on hover for any module like this */
      #pulseaudio:hover {
          background-color: #a37800;
      }
      
      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
	  color: @overlay0;
      }
      
      #workspaces button:hover {
          color: @red;
	  background-color: rgba(0, 0, 0, 0.2);
      }
      
      #workspaces button.persistent {
          color: @mauve;
      }
      
      #workspaces button.active {
          color: @rosewater;
	  background-color: rgba(246, 215, 214, 0.1);
	  font-weight: bold;
	  border-bottom: 3px solid @rosewater
      }
      
      #workspaces button.deafult {
          color: @mauve;
      }
      
      #workspaces button.empty {
          color: @surface0;
      }
      
      #workspaces button.urgent {
          background-color: @red;
	  color: @base
      }
      
      #mode {
          background-color: #64727D;
          box-shadow: inset 0 -3px #ffffff;
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #power-profiles-daemon,
      #custom-weather,
      #custom-bluelight,
      #custom-power-menu,
      #mpd {
          padding: 0 10px;
          color: #ffffff;
          margin: 0px;
      }
      
      #window,
      #workspaces {
          background-color: @base;
          border-radius: 10px;
	  padding: 3px;
	  margin: 3px 0px;
          padding-right: 4px;
      }
      
      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
          margin-right: 0;
      }
      
      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
          margin-left: 0;
      }
      
      #clock {
          background-color: @base;
          color: @blue;
          border-radius: 10px 0px 0px 10px;
          margin-left: 7px;
      }
      
      #custom-power-menu {
          background-color: @base;
          color: @flamingo;
          margin-right: 3.5px;
          border-radius: 0px 10px 10px 0px;
          padding-left: 0px;
          padding-right: 10px;
      }
      
      #battery.charging, #battery.plugged {
          color: @flamingo;
          background-color: @base;
          padding-left: 0px;
      }
      
      #custom-weather {
          background-color: @base;
          color: @sky;
          padding-left: 0px;
          border-radius: 0px 10px 10px 0px;
          margin-right: 3.5px;
          padding-right: 3px;
      }
      
      #custom-bluelight {
          background-color: @base;
          color: @sky;
          padding-left: 0px;
          padding-right: 5px;
      }
      
      #power-profiles-daemon {
          padding-right: 15px;
          border-radius: 10px;
          margin-left: 3.5px;
          margin-right: 7px;
      }
      
      #power-profiles-daemon.performance {
          background-color: @red;
          color: #ffffff;
      }
      
      #power-profiles-daemon.balanced {
          background-color: @blue;
          color: @base;
      }
      
      #power-profiles-daemon.power-saver {
          background-color: @green;
          color: @base;
      }
      
      label:focus {
          background-color: #000000;
      }
      
      #cpu {
          background-color: @base;
          color: @red;
          margin-left: 3.5px;
          border-radius: 10px 0px 0px 10px;
      }
      
      #memory {
          background-color: @base;
          color: @mauve;
          padding-left: 0px;
      }
      
      #disk {
          background-color: #964B00;
      }
      
      #backlight {
          background-color: @base;
          color: @yellow;
          border-radius: 0px 10px 10px 0px;
          margin-right: 3.5px;
          padding-left: 0px;
      }
      
      #network {
          background-color: @base;
          color: @lavender;
          padding-left: 0px;
          padding-right: 3.5px;
      }
      
      #network.disconnected {
          background-color: @base;
          color: @red;
          padding-left: 0px;
      }
      
      #pulseaudio {
          background-color: @base;
          color: @green;
          border-radius: 10px 0px 0px 10px;
      }
      
      #pulseaudio.microphone {
          background-color: @base;
          color: @peach;
          border-radius: 0px 0px 0px 0px;
          padding-left: 0px;
      }
      
      #wireplumber {
          background-color: #fff0f5;
          color: #000000;
      }
      
      #wireplumber.muted {
          background-color: #f53c3c;
      }
      
      #custom-media {
          background-color: #66cc99;
          color: #2a5c45;
          min-width: 100px;
      }
      
      #custom-media.custom-spotify {
          background-color: #66cc99;
      }
      
      #custom-media.custom-vlc {
          background-color: #ffa000;
      }
      
      #temperature {
          background-color: @base;
          color: @blue;
          padding-left: 0px;
      }
      
      #temperature.critical {
          background-color: @base;
          color: @red;
          padding-left: 0px;
      }
      
      #tray {
          background-color: @base;
          border-radius: 10px;
          margin-left: 3.5px;
      }
      
      #tray > .passive {
          -gtk-icon-effect: dim;
      }
      
      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }
      
      #idle_inhibitor {
          background-color: #2d3436;
      }
      
      #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
      }
      
      #mpd {
          background-color: #66cc99;
          color: #2a5c45;
      }
      
      #mpd.disconnected {
          background-color: #f53c3c;
      }
      
      #mpd.stopped {
          background-color: #90b1b1;
      }
      
      #mpd.paused {
          background-color: #51a37a;
      }
      
      #language {
          background: #00b093;
          color: #740864;
          padding: 0 5px;
          min-width: 16px;
      }
      
      #keyboard-state {
          background: #97e1ad;
          color: #000000;
          padding: 0 0px;
          min-width: 16px;
      }
      
      #privacy {
          padding: 0;
      }
      
      #privacy-item {
          padding: 0 5px;
          color: white;
      }
      
      #privacy-item.screenshare {
          background-color: #cf5700;
      }
      
      #privacy-item.audio-in {
          background-color: #1ca000;
      }
      
      #privacy-item.audio-out {
          background-color: #0069d4;
      }
    '';
  };
  
  # Install required packages for your waybar setup
  home.packages = with pkgs; [
    wttrbar # For weather
    fontconfig # For fonts
    pavucontrol # For audio control
  ];
  
  # Install required fonts
  fonts.fontconfig.enable = true;
  
  # Create power menu script directory
  xdg.configFile."waybar/scripts/power-menu/powermenu.sh" = {
    text = ''
      #!/bin/bash
      
      # Simple power menu using wofi
      
      # Options
      shutdown="Shutdown"
      reboot="Reboot"
      logout="Logout"
      
      # Get choice
      chosen=$(printf "%s\n%s\n%s" "$shutdown" "$reboot" "$logout" | wofi --dmenu --prompt "Power Menu" --width 200 --height 180 --location 3 --yoffset 35 --xoffset -35)
      
      # Execute command based on choice
      case "$chosen" in
          "$shutdown")
              systemctl poweroff
              ;;
          "$reboot")
              systemctl reboot
              ;;
          "$logout")
              hyprctl dispatch exit
              ;;
      esac
    '';
    executable = true;
  };
}
