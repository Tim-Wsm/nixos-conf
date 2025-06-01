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
    discord
    # screenshots & simple foto editing
    gthumb
    gimp
    # image viewing + editing
    feh
    loupe
    imagemagick
    upscayl
    # pdf reading + editing
    evince
    xournalpp
    # learning
    anki
  ];
}
