{pkgs, ...}: {
  # dependencies for sound
  environment.systemPackages = with pkgs; [
    pavucontrol
  ];

  # enable sound via pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
