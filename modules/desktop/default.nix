{...}: {
  imports = [
    ./themes.nix
    ./wayland/sway.nix
    ./x11/i3.nix
    ./mixed/gnome.nix
  ];
}
