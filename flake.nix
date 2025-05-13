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
      
      # Import your hardware configuration
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {  # Using 'nixos' as hostname from your config
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix

	    # Import gaming module at system level
            ./modules/gaming/amd.nix
            ./modules/gaming/steam.nix
           
	    # Import system modules
	    ./modules/system/shell.nix

	    ] ++ sharedModules ++ [

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
          ];
        };
      };
    };

    # ISO installer configuration
        installer = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Base installer module
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
            
            # Custom installer configuration
            ./modules/installer/configuration.nix
          ] ++ sharedModules;
        };
      };
      
      # ISO output for easy building
      packages.${system} = {
        iso = self.nixosConfigurations.installer.config.system.build.isoImage;
      };

      # Default package is the ISO
      defaultPackage.${system} = self.packages.${system}.iso;
    };
}
