{ config, pkgs, lib, ... }:

{
  # Enable automatic garbage collection
  nix = {
    # Garbage collection settings
    gc = {
      automatic = true;
      dates = "weekly";  # Run GC once a week
      options = "--delete-older-than 30d";  # Delete generations older than 30 days
      persistent = true;  # Persist the GC configurations across reboots
    };

    # Optimize Nix store
    settings = {
      # Automatically optimize the Nix store to save space
      auto-optimise-store = true;
      
      # Keep outputs around for faster subsequent builds
      keep-outputs = true;
      
      # Keep build derivations to help with debugging failed builds
      keep-derivations = true;
      
      # Continue building other derivations if one fails
      keep-going = true;
      
      # Show more detailed information about builds
      show-trace = true;
      
      # Warn about dirty git tree when building from git
      warn-dirty = true;
      
      # Experimental features for flakes
      experimental-features = [ "nix-command" "flakes" ];
      
      # Max number of parallel jobs
      max-jobs = "auto";
      
      # Allow the substitution of non-free packages from binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    
    # Cleanup the Nix registry
    registry.nixpkgs.flake = pkgs.nixpkgs;
  };

  # Also optimize the disk space by configuring systemd to cleanup journal files
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=1week
  '';

  # Add aliases for common Nix garbage collection commands
  environment.shellAliases = {
    nix-cleanup = "sudo nix-collect-garbage --delete-older-than 30d";
    nix-cleanup-all = "sudo nix-collect-garbage -d";
    nix-cleanup-boot = "sudo /run/current-system/bin/switch-to-configuration boot";
    nix-du = "nix path-info -rSsh";
    nix-gc-list = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
  };

  # Install packages for Nix maintenance
  environment.systemPackages = with pkgs; [
    nix-du          # Visualize Nix store usage
    nix-index       # Locate packages containing certain files
    nix-tree        # Interactively browse dependency graphs
    nix-diff        # Explain why two Nix derivations differ
    nixfmt          # Format Nix code
  ];
}
