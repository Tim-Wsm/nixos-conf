{pkgs, ...}: let
  # enable blueray support for vlc and handbrake
  libbluray = pkgs.libbluray.override {
    withAACS = true;
    withBDplus = true;
  };
  vlc = pkgs.vlc.override {inherit libbluray;};
  handbrake = pkgs.handbrake.override {inherit libbluray;};
in {
  # programs used for video playback
  environment.systemPackages = with pkgs; [
    vlc
    libvlc
    mpv
    handbrake
  ];
}
