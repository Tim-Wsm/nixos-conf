{
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
}
