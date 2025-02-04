{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = let
    # Uses the logo from the nixos-artwork repo for the notification.
    logo-path = "${inputs.nixos-artwork}/logo/nix-snowflake-colours.svg";
    # Compare the commit hash of nixpkgs input of the flake.lock of the current
    # system and the head of the remote branch and notify the user of the
    # result.
    nix-update-reminder = pkgs.writeShellScriptBin "nix-update-reminder" ''
      flake_path="${inputs.self}"
      flake_json=$(${pkgs.nix}/bin/nix flake metadata $flake_path --json)
      local_rev=$(echo $flake_json | ${pkgs.jq}/bin/jq '.locks.nodes.nixpkgs.locked.rev' | tr -d '"')
      branch=$(echo $flake_json | ${pkgs.jq}/bin/jq '.locks.nodes.nixpkgs.original.ref' | tr -d '"')
      remote_rev=$(${pkgs.git}/bin/git ls-remote https://github.com/NixOS/nixpkgs -b $branch | sed 's/\s.*$//')

      if [[ "$local_rev" == "$remote_rev" ]]; then
          ${pkgs.libnotify}/bin/notify-send -i ${logo-path} "   $branch: up-to-date"
      else
           ${pkgs.libnotify}/bin/notify-send -i ${logo-path} "   $branch: updates available"
      fi
    '';
    # Run the update reminder 10 minutes after startup, then every 2 hours.
    nix-update-reminder-daemon = pkgs.writeShellScriptBin "nix-update-reminder-daemon" ''
          sleep 600
      while :
      do
          ${nix-update-reminder}/bin/nix-update-reminder
          sleep 7200
      done
    '';
  in [
    nix-update-reminder
    nix-update-reminder-daemon
  ];
}
