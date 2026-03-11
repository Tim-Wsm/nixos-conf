{...}: {
  imports = [
    ./themes.nix
    ./wayland/sway.nix
    ./x11/i3.nix
    ./wayland/cosmic.nix
    # ./mixed/gnome.nix
  ];
}
