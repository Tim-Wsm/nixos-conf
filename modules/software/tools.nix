{pkgs, ...}: {
  # programs without special configuration
  environment.systemPackages = with pkgs; [
    # file browsing
    nautilus
    nautilus-open-any-terminal
    # password management
    keepassxc
    # messaging
    telegram-desktop
    signal-desktop
    # screenshots & simple foto editing
    gthumb
    gimp
    # image viewing + editing
    feh
    loupe
    imagemagick
    # pdf reading + editing
    evince
    kdePackages.okular
    xournalpp
    # learning
    anki
  ];
}
