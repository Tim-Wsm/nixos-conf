{pkgs, ...}: {
  # add thunderbird and protonmail bridge as packages
  environment.systemPackages = [
    pkgs.thunderbird
    pkgs.protonmail-bridge-gui
  ];
}
