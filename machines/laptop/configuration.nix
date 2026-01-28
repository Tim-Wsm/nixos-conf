{
  inputs,
  pkgs,
  ...
}: {
  # enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # imports for all modules
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../modules/system/default.nix
    ../../modules/system/bluetooth.nix
    ../../modules/desktop/themes.nix
    ../../modules/desktop/wayland/sway.nix
    ../../modules/software/neovim.nix
    ../../modules/software/tools.nix
    ../../modules/software/browser.nix
    ../../modules/software/e-mail.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "tim-laptop"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;

  # Disable speechd to reduce image size.
  # see: https://nixcademy.com/de/posts/minimizing-nixos-images/
  services.speechd.enable = false;

  # Pass hostname to home-manager
  home-manager.extraSpecialArgs = {
    hostname = "tim-laptop";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tim = {
    isNormalUser = true;
    description = "tim";
    extraGroups = ["networkmanager" "wheel" "video"];
    packages = [];
  };

  # enable gvfs support
  services.gvfs.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # default home manager configuration
  home-manager.users.tim = {...}: {
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };
}
