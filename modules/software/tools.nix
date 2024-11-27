{pkgs, ...}: {
  # programs without special configuration
  environment.systemPackages = with pkgs; [
    # password management
    keepassxc
    # messaging
    telegram-desktop
    discord
    vesktop
    # screenshots & simple foto editing
    shutter
    gthumb
    gimp
    # video playback
    vlc
    mpv
    # image upscaling
    upscayl
    # pdf editing
    xournalpp
  ];
}
