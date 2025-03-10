{
  description = "Flake for building my NixOS.";

  inputs = {
    # use nixpkgs unstable channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # use home-manager to manage the user and home configuration
    home-manager = {
      # use the main branch of home-manager
      url = "github:nix-community/home-manager";
      # require home-manager to use the same nixpkgs channel as the system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use stylix for consistent themes
    stylix = {
      # use the main branch of stylix
      url = "github:danth/stylix";
      # require stylix to use the same nixpkgs channel as the system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use my custom nixvim config to manage the neovim install and configuration
    nixvim-flake = {
      url = "github:Tim-Wsm/nixvim-conf";
      # require nixvim to use the same nixpkgs channel as the system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use nixos-artwork for wallpaper and logo
    nixos-artwork = {
      url = "github:NixOS/nixos-artwork";
      # this is not a flake
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: {
    nixosConfigurations.tim-pc = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      # pass the flake inputs into all sub-modules
      specialArgs = {
        inherit inputs;
        inherit system;
      };

      modules = [
        home-manager.nixosModules.default
        stylix.nixosModules.stylix
        ./machines/personal-computer/configuration.nix
      ];
    };

    nixosConfigurations.tim-laptop = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      # pass the flake inputs into all sub-modules
      specialArgs = {
        inherit inputs;
        inherit system;
      };

      modules = [
        home-manager.nixosModules.default
        stylix.nixosModules.stylix
        ./machines/laptop/configuration.nix
      ];
    };

    nixosConfigurations.tim-vbox = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      # pass the flake inputs into all sub-modules
      specialArgs = {
        inherit inputs;
        inherit system;
      };

      modules = [
        home-manager.nixosModules.default
        stylix.nixosModules.stylix
        ./machines/virtualbox/configuration.nix
      ];
    };

    nixosConfigurations.tim-dbg = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # pass the flake inputs into all sub-modules
      specialArgs = {inherit inputs;};

      modules = [
        ./machines/vm-debug/configuration.nix
      ];
    };
  };
}
