{
  description = "NixOS configuration with Hyprland and Catppuccin Mocha theme";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland.url = "github:hyprwm/Hyprland";
    
    # Optional: Catppuccin theme as a flake
    catppuccin-nix = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, hyprland, catppuccin-nix, ... }@inputs:
    let
      system = "x86_64-linux"; # Adjust for your system architecture
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Define shared modules
      sharedModules = [
        ./modules/gaming/amd.nix
        ./modules/gaming/steam.nix
      ];
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {  # Using 'nixos' as hostname from your config
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            # Import system modules
            ./modules/system/shell.nix
	    ./modules/system/nix/gc.nix
            # Import Hyprland NixOS module
            hyprland.nixosModules.default
            
            # Home Manager module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.kari = import ./home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ] ++ sharedModules;
        };
      };
    };
}
