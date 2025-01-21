{
  pkgs,
  inputs,
  system,
  ...
}: {
  # override neovim package with my custom nixvim configuration
  nixpkgs.overlays = let
    nixvim-overlay = final: prev: {
      neovim = inputs.nixvim-flake.packages.${system}.default;
    };
  in [nixvim-overlay];

  # optional dependencies for my custom nixvim configuration
  environment.systemPackages = [
    pkgs.ripgrep
    pkgs.alejandra
  ];
}
