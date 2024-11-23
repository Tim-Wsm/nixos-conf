{
  inputs,
  pkgs,
  config,
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
    ../../modules/desktop/default.nix
    ../../modules/software/default.nix
    ../../modules/services/ssh_server.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "tim-pc"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Pass hostname to home-manager
  home-manager.extraSpecialArgs = {
    hostname = "tim-pc";
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # Configure nvidia driver
  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Disable power management (on this cpu the gpu is always required)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use open source kernel module (this is NOT "nouveau"
    open = true;

    # Use the latest stable version of the driver
    # TODO: switch back to stable, once the driver compiles for the most recent
    # linux kernel
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Disable mouse acceleration glbally for this machine
  services.libinput.mouse.accelProfile = "flat";

  # Setup both monitors on this machine
  services.xserver = {
    # Set resolution, refresh rate and position of monitors. This specific
    # configuration has been taken from an xorg.conf generated by
    # nvidia-settings.
    screenSection = ''
      Option "metamodes" "DP-0: 2560x1440_144 +1080+240, HDMI-0: nvidia-auto-select +0+0 {rotation=left}"
      Option "DPI" "96 x 96"
    '';

    # Select DP-0 as the primary output. Options on the resolution, refresh
    # rate and position do not work here.
    xrandrHeads = [
      {
        output = "DP-0";
        primary = true;
        # set display size in millimeters for correct DPI
        monitorConfig = ''
          DisplaySize 595 335
        '';
      }
      {
        output = "HDMI-0";
        # set display size in millimeters for correct DPI
        monitorConfig = ''
          DisplaySize 300 533
        '';
      }
    ];
  };

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

  # default home manager configuration
  home-manager.users.tim = {...}: {
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };
}
