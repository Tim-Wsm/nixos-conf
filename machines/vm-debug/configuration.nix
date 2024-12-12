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
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "tim-dbg"; # Define your hostname.
  networking.networkmanager.enable = true;

  # define vm test user
  users.users.tim = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = ["networkmanager" "wheel"];
  };

  # define memory and number of cores for the vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096; # Use 4096MiB memory.
      cores = 4;
    };
  };

  # Add git and neovim to work with nix config and nixpkgs
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  # delete content of /tmp/ on reboot (prevents pile up of old build files)
  boot.tmp.cleanOnBoot = true;

  # increase the number of open files (fixes some build issues with older nix
  # versions)
  systemd.extraConfig = "DefaultLimitNOFILE=4096";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # debug setup uses a default sway for graphics
  programs.sway = {
    enable = true;
  };
}
