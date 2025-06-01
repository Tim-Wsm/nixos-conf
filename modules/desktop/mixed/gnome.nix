{...}: {
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    options = "caps:escape";
  };

  # Enable gnome desktop and gdm as display manager.
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}
