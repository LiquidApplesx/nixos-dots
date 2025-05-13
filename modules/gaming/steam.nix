{ config, pkgs, lib, ... }:

{
  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;  # Open ports for Remote Play
    dedicatedServer.openFirewall = true;  # Open ports for dedicated servers
  };
  
  # Allow Steam to access controllers
  hardware.steam-hardware.enable = true;
  
  # Enable GameMode for better performance when gaming
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;  # Increase process priority
        ioprio = 0;   # Set I/O priority to highest
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;  # First GPU
        amd_performance_level = "high";  # Set AMD GPU to high performance
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
 
  # Gaming-related packages
  environment.systemPackages = with pkgs; [
    # Must-have gaming tools
    gamescope         # Microcompositor for games
    mangohud          # Performance overlay
    lutris            # Game launcher
    protontricks      # Wine/Proton prefix manager
    wineWowPackages.stable  # Wine stable version
    winetricks        # Tools for Wine
    protonup-qt       # Proton GE manager
    
    # Performance optimization tools
    gamemode          # Optimize system for games
    
    # Additional tools
    bottles           # Alternative Wine manager
    heroic            # Epic Games, GOG, and Amazon Games launcher
    prismlauncher     # Minecraft launcher
    legendary-gl      # Epic Games Store CLI
  ];
  
  # Allow gamescope to capture inputs
  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = ''
    # Allow gamescope to capture inputs
    KERNEL=="uinput", TAG+="uaccess"
  '';
  
  # Better audio for games
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Low-latency audio
    extraConfig = {
      pipewire = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 32;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 32;
	};
      };
    };
  };

  # MangoHud configuration via environment
  environment.variables = {
    # Set up MangoHud to be available for all Vulkan applications
    MANGOHUD = "1";
    # Configure MangoHud display
    MANGOHUD_CONFIG = "cpu_temp,gpu_temp,vram,ram,position=top-left,height=500,font_size=20";
  };
  
  # Create a MangoHud config directory
  environment.etc."xdg/MangoHud/MangoHud.conf".text = ''
    ### MangoHud configuration file
    legacy_layout=0
    horizontal
    gpu_stats
    gpu_temp
    gpu_load_change
    cpu_stats
    cpu_temp
    cpu_mhz
    cpu_load_change
    ram
    vram
    fps
    engine_version
    vulkan_driver
    frame_timing=1
    frametime
    frametimes_threshold=25,40
    hud_no_margin
    table_columns=14
    font_size=20
    background_alpha=0.4
    position=top-left
    toggle_hud=Shift_R+F12
    toggle_logging=F11
    output_file=/tmp/mangohud_log_%app_name%.csv
  '';
}
