{...}: {
  imports = [
    ./code.nix
    ./neovim.nix
    ./emacs.nix
    ./tools.nix
    ./browser.nix
    ./e-mail.nix
    ./games.nix
    ./scripts/nix-update-diff.nix
  ];
}
