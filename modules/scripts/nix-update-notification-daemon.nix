{
  pkgs,
  inputs,
  ...
}: let
  nix-check-updates = pkgs.callPackage ./nix-check-updates.nix {inherit inputs;};
in
  pkgs.writeShellScriptBin "nix-update-notification-daemon" ''
    sleep 10
    while :
    do
        ${nix-check-updates}/bin/nix-check-updates
        sleep 7200
    done
  ''
