{pkgs, ...}: let
  # enable blueray support for vlc and handbrake
  libbluray = pkgs.libbluray.override {
    withAACS = true;
    withBDplus = true;
  };
  #vlc = pkgs.vlc.override {inherit libbluray;};
  handbrake = pkgs.handbrake.override {inherit libbluray;};
in {
  environment.systemPackages = with pkgs; [
    # programs used for video playback
    vlc
    libvlc
    mpv
    # TODO: reenable handbrake once ffmpeg builds again
    # handbrake
    # enable HEIC image preview in nautilus
    pkgs.libheif
    pkgs.libheif.out
  ];

  # enable gstreamer extension for nautilus
  nixpkgs.overlays = [
    (final: prev: {
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs =
          nprev.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });
    })
  ];

  # enable HEIC image preview in nautilus
  environment.pathsToLink = ["share/thumbnailers"];
}
