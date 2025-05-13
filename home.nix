{ config, pkgs, inputs, ... }:

{
  # Let Home Manager manage itself
  programs.home-manager.enable = true;
 
  imports = [
    ./modules/desktop/hyprland.nix
    ./modules/desktop/waybar.nix
    ./modules/theming/catppuccin.nix
    ./modules/theming/wallpaper.nix
    ./modules/shell/zsh.nix
    # Add more modules as needed
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "kari";
  home.homeDirectory = "/home/kari";
  
  # Packages specific to your user environment
  home.packages = with pkgs; [
    # Desktop environment packages 
    fastfetch
    firefox-devedition-bin
    gamescope
    github-cli
    git
    lazygit
    lutris
    neovim
    steam
  ];

  # MangoHud configuration for the user
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
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

  # This value determines the Home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "24.11";
}
