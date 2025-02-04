{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = let
    nix-check-updates =
      pkgs.callPackage ./nix-check-updates.nix {inherit inputs;};
    nix-update-notification-daemon =
      pkgs.callPackage ./nix-update-notification-daemon.nix {inherit inputs;};
  in [
    nix-check-updates
    nix-update-notification-daemon
  ];
}
