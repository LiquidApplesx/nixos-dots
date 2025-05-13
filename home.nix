{ config, pkgs, inputs, ... }:

{
  # Let Home Manager manage itself
  programs.home-manager.enable = true;
 
  imports = [
    ./modules/desktop/hyprland.nix
    ./modules/theming/catppuccin.nix
    ./modules/shell/zsh.nix
    ./modules/gaming
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
    github-cli
    git
    neovim
    steam
  ];
  
  # This value determines the Home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "24.11";
}
