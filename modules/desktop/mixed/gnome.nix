{...}: {
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    options = "caps:escape";
  };

  # xserver
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}
