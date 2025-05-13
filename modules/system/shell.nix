{ config, pkgs, ... }:

{
  # Enable ZSH system-wide
  programs.zsh.enable = true;
  
  # Set ZSH as default shell for your user
  users.users.kari.shell = pkgs.zsh;
  
  # Install some useful system-wide shell utilities
  environment.systemPackages = with pkgs; [
    zsh
    fzf
    bat
    eza
    ripgrep
    fd
    lsd
  ];
}
