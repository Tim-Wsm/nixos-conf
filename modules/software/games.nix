{pkgs, ...}: {
  # configure steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

    # required for some games (see https://nixos.wiki/wiki/Steam)
    gamescopeSession.enable = true;
  };

  # other programs for gaming
  environment.systemPackages = with pkgs; [
    # bottles for windows games
    bottles
  ];
}
