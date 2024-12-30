{pkgs, ...}: {
  # programs without special configuration
  environment.systemPackages = with pkgs; [
    # password management
    keepassxc
    # messaging
    telegram-desktop
    signal-desktop
    discord
    vesktop
    # screenshots & simple foto editing
    gthumb
    gimp
    # video playback
    vlc
    mpv
    # image editing
    imagemagick
    upscayl
    # pdf editing
    xournalpp
  ];
}
