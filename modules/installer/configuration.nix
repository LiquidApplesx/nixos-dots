{ config, pkgs, lib, inputs, ... }:

{
  # Import Hyprland
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  # Enable gaming support in the installer
  programs.steam.enable = lib.mkForce false; # Disable Steam in the installer
  hardware.steam-hardware.enable = lib.mkForce false; # Disable Steam hardware in the installer
  
  # Basic system configuration for the installer
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "amd_pstate=active" ];
  };
  
  # Graphical environment for the installer
  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      # Auto-login to the live system
      autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
  };
  
  # Enable Hyprland for the installer
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  # Include core gaming/AMD packages in the installer
  environment.systemPackages = with pkgs; [
    # Installer utilities
    gparted
    firefox
    kitty
    neovim
    
    # Diagnostic tools
    pciutils
    usbutils
    lshw
    hwinfo
    glxinfo
    vulkan-tools
    
    # Gaming utilities (minimal set for testing/validation)
    mangohud
    corectrl
    radeontop
    lm_sensors
  ];
  
  # Add Catppuccin theme to the installer
  environment.variables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Mauve-Dark";
  };
  
  # Basic installer theming
  environment.etc = {
    # Add a Catppuccin wallpaper
    "xdg/wallpaper.png".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/minimalistic/catppuccin_gradient.png"\;
      sha256 = "sha256-qmOJg7u6GVnQnqNG4NJbqCEkD4zTrV6+wd8FzQ6lBzs=";
    };
    
    # Add a welcome message
    "issue".text = ''
      
      \e[1;35m   _   _ _      ___  ____    \e[0m
      \e[1;35m  | \ | (_)_  _/ _ \/ ___|   \e[0m
      \e[1;35m  |  \| | \ \/ / | | \___ \  \e[0m
      \e[1;35m  | |\  | |>  <| |_| |___) | \e[0m
      \e[1;35m  |_| \_|_/_/\_\\___/|____/  \e[0m
      \e[1;36m                             \e[0m
      \e[1;36m  Hyprland + Catppuccin + Gaming Edition\e[0m
      \e[1;32m  Boot completed. Login as 'nixos' user to continue.\e[0m
      \e[1;32m  Run 'sudo nixos-install' to install the system.\e[0m
      
    '';
  };
  
  # Auto-start Hyprland for the nixos user
  systemd.user.services.hyprland = {
    description = "Hyprland - Wayland Compositor";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprland}/bin/Hyprland";
      Restart = "on-failure";
    };
  };
  
  # Configure the Hyprland session for the live user
  environment.etc."xdg/hypr/hyprland.conf".text = ''
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
    exec-once = kitty
    
    # Input config
    input {
        kb_layout = us
        follow_mouse = 1
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
    
    # Keybindings
    $mainMod = SUPER
    
    # Basic keybinds
    bind = $mainMod, Return, exec, kitty
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, firefox
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, R, exec, wofi --show drun
    
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
    
    # Move windows to workspaces
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    
    # Mouse bindings
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
  '';
}
