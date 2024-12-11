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

    # use nixvim to manage the neovim install and configuration
    nixvim = {
      # use the main branch of nixvim
      url = "github:nix-community/nixvim";
      # require nixvim to use the same nixpkgs channel as the system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use stylix for consistent themes
    stylix = {
      # use the main branch of stylix
      url = "github:danth/stylix";
      # require stylix to use the same nixpkgs channel as the system
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: {
    nixosConfigurations.tim-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # pass the flake inputs into all sub-modules
      specialArgs = {inherit inputs;};

      modules = [
        home-manager.nixosModules.default
        stylix.nixosModules.stylix
        ./machines/personal-computer/configuration.nix
      ];
    };

    nixosConfigurations.tim-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # pass the flake inputs into all sub-modules
      specialArgs = {inherit inputs;};

      modules = [
        home-manager.nixosModules.default
        stylix.nixosModules.stylix
        ./machines/laptop/configuration.nix
      ];
    };

    nixosConfigurations.tim-vbox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # pass the flake inputs into all sub-modules
      specialArgs = {inherit inputs;};

      modules = [
        home-manager.nixosModules.default
        stylix.nixosModules.stylix
        ./machines/vm-debug/configuration.nix
      ];
    };

    nixosConfigurations.tim-dbg = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # pass the flake inputs into all sub-modules
      specialArgs = {inherit inputs;};

      modules = [
        ./machines/virtualbox-debug/configuration.nix
      ];
    };
  };
}
