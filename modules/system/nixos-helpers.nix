{pkgs, ...}: {
  # nixos helper tools
  environment.systemPackages = with pkgs; [
    # yet another nixos helper
    nh
    # diff tool
    nvd
    # wrapperh for nixos-rebuild for nice output
    nix-output-monitor
    # autoformater
    alejandra
    # nixpkg review tool
    nixpkgs-review
  ];
}
