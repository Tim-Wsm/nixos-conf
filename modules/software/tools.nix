{pkgs, ...}: {
  # programs without special configuration
  environment.systemPackages = with pkgs; [
    telegram-desktop
    discord
    keepassxc
    vlc
    mpv
  ];
}
