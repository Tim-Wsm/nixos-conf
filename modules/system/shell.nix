{pkgs, ...}: {
  # Configure console keymap
  console.keyMap = "de";

  # default shell tools
  environment.systemPackages = with pkgs; [
    # tools
    git
    wget
    curl
    htop
    tree
    killall
    calc
    # hardware info
    lshw
    usbutils
    # editors
    vim
    neovim
    # nixos helpers
    nh
    nvd
    nix-output-monitor
  ];

  # setup fish as default  shell
  programs.fish = {
    enable = true;
    shellInit = ''
      fish_vi_key_bindings
    '';
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };
  users.users.tim.shell = pkgs.fish;

  # set environment variables
  environment.sessionVariables = {
    # set default editors
    EDITOR = "${pkgs.neovim}/bin/nvim";
    VISUAL = "${pkgs.neovim}/bin/nvim";
  };
}
