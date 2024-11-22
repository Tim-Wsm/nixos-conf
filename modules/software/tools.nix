{pkgs, ...}: {
  # programs without special configuration
  environment.systemPackages = with pkgs; [
    # password management
    keepassxc
    # messaging
    telegram-desktop
    discord
    # screenshots & simple foto editing
    shutter
    gthumb
    gimp
    # video playback
    vlc
    mpv
  ];
}
