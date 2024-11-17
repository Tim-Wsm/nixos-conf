{pkgs, ...}: {
  # include polybar
  imports = [
    ./polybar.nix
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    options = "caps:escape";
  };

  # dependencies for my i3 environment
  environment.defaultPackages = with pkgs; [
    # application runner
    rofi-wayland
    # terminal
    alacritty
    # applets
    networkmanagerapplet
    # notifications
    libnotify
    dunst
    # for wallpaper
    feh
    # backlight
    brightnessctl
    # screenshots
    shutter
  ];

  # fix for gnome programs running outside of gnome
  programs.dconf.enable = true;

  # setup xserver and display manager
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager.gdm.enable = true;
  };

  # configuration of sway
  home-manager.users.tim = {
    pkgs,
    lib,
    tiling-manager-theme,
    hostname,
    ...
  }: {
    xsession.windowManager.i3 = {
      enable = true;
      config = let
        mod = "Mod4"; # use the super key
      in {
        # disable default bar
        bars = [];

        # set font size to 8
        fonts = lib.mkForce {
          size = "8.0";
        };

        # configure launcher and terminal
        modifier = "${mod}";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.rofi-wayland}/bin/rofi -show run";

        # set inputs
        keybindings = let
          i3lock = "${pkgs.i3lock}/bin/i3lock";
          pactl = "pactl";
          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        in
          lib.mkOptionDefault {
            # change focus
            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";

            # move windows
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";

            # lockscreen
            "${mod}+m" = "exec ${i3lock} -c 000000";

            # brightness
            "XF86MonBrightnessUp" = let
              increase-brightness =
                pkgs.writeShellScript "increase-brightness" "${brightnessctl} set 5%+";
            in "exec ${increase-brightness}";
            "XF86MonBrightnessDown" = let
              decrease-brightness =
                pkgs.writeShellScript "decrease-brightness" "${brightnessctl} set 5%-";
            in "exec ${decrease-brightness}";

            # volume control
            "XF86AudioRaiseVolume" = let
              increase-volume = pkgs.writeShellScript "increase-volume" ''
                ${pactl} set-sink-mute 0 false
                ${pactl} set-sink-volume 0 +1%
              '';
            in "exec ${increase-volume}";
            "XF86AudioLowerVolume" = let
              decrease-volume = pkgs.writeShellScript "decrease-volume" ''
                ${pactl} set-sink-mute 0 false
                ${pactl} set-sink-volume 0 -1%
              '';
            in "exec ${decrease-volume}";
            "XF86AudioMute" = "exec '${pactl} set-sink-mute 0 toggle'";
          };

        # hide borders
        window.hideEdgeBorders = "both";

        # startup command
        startup = let
          start-polybar =
            if hostname == "tim-pc"
            then
              pkgs.writeShellScript "start-polybar" ''
                MONITOR=DP-0 polybar --reload main &
                MONITOR=HDMI-0 polybar --reload secondary
              ''
            else
              pkgs.writeShellScript "start-polybar" ''
                polybar --reload main
              '';
        in [
          {
            command = "${start-polybar}";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.dunst}/bin/dunst";
            notification = false;
          }
          {
            command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
            notification = false;
          }
        ];

        # set colors to theme defined in theme.nix
        colors = lib.mkForce tiling-manager-theme.colors;
      };
    };
  };
}
