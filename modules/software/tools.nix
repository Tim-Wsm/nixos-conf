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
    # video playback
    vlc
    mpv
    # image viewing + editing
    feh
    imagemagick
    upscayl
    # pdf reading + editing
    okular
    evince
    xournalpp
    # learning
    anki
  ];
}
