{pkgs, ...}: {
  # enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # imports modules
  # for debugging, import modules to investigate
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/locale.nix
    ../../modules/system/shell.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "tim-dbg"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tim = {
    isNormalUser = true;
    description = "tim";
    extraGroups = ["networkmanager" "wheel" "video"];
    packages = [];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?



  # debug setup uses a default i3 and lightdm for graphics
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    xkb = {
      layout = "de";
      options = "caps:escape";
    };
  };

}