{
  pkgs,
  inputs,
  ...
}: {
  # import waybar
  imports = [
    ./waybar.nix
    ./swaync.nix
  ];

  # dependencies for my sway environment
  environment.systemPackages = with pkgs; [
    # terminal
    alacritty
    # backlight
    brightnessctl
    # wayland utils
    xdg-utils
    grim
    slurp
    wl-clipboard
    # applets
    networkmanagerapplet
    # notifications
    libnotify
    swaynotificationcenter
    # wallpaper
    swaybg
    # music control
    playerctl
  ];

  # Use gdm as the display manager.
  services.displayManager.gdm.enable = true;

  # setup sway (see https://nixos.wiki/wiki/Sway)
  programs.sway.enable = true; # enable sway (reqiuired to make sway visible in gdm)
  security.polkit.enable = true; # required to setup sway in home-manager
  services.gnome.gnome-keyring.enable = true; # to store secrets in gnome-keyring via DBus
  security.pam.services.swaylock = {}; # ensures that swaylock works

  # fix for gnome programs running outside of gnome
  programs.dconf.enable = true;

  # special optimizations for sway (see https://nixos.wiki/wiki/Sway)
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];

  # enable gvfs for nautilus
  services.gvfs.enable = true;

  # configuration of sway
  home-manager.users.tim = {
    pkgs,
    lib,
    tiling-manager-theme,
    hostname,
    ...
  }: {
    # enable xdg portal for drag&drop and desktop sharing
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
      config.common.default = "*";
    };

    # rofi configuration (the application runner)
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      font = lib.mkForce "Noto Sans Mono 14";
    };

    # sway configuration
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures = {gtk = true;};
      systemd.enable = true;

      extraOptions = [
        "--unsupported-gpu"
      ];

      config = rec {
        startup = let
          nix-update-notification-daemon = pkgs.callPackage ./../../scripts/nix-update-notification-daemon.nix {inherit inputs;};
        in [
          {command = "${pkgs.waybar}/bin/waybar";}
          {command = "${pkgs.swaynotificationcenter}/bin/swaync";}
          {command = "${pkgs.networkmanagerapplet}/bin/nm-applet";}
          {command = "${pkgs.blueman}/bin/blueman-applet";}
          {command = "${nix-update-notification-daemon}/bin/nix-update-notification-daemon";}
        ];

        # disable default bar
        bars = [];

        # set font size to 8
        fonts = lib.mkForce {
          size = "8.0";
        };

        # configure launcher and terminal
        modifier = "Mod4";
        menu = "${pkgs.rofi-wayland}/bin/rofi -show drun";
        terminal = "${pkgs.alacritty}/bin/alacritty";

        # set inputs
        input = {
          "*" = {
            xkb_layout = "de";
            xkb_variant = "nodeadkeys";
            xkb_options = "caps:escape";
            repeat_delay = "400";
            repeat_rate = "40";
          };

          # disable mouse acceleration for Logitech G604
          "1133:16517:Logitech_G604" = {
            accel_profile = "flat";
          };
        };

        # set outputs
        output =
          if hostname == "tim-pc"
          then {
            DP-1 = {
              pos = "0 0";
              mode = "2560x1440@144Hz";
            };
            HDMI-A-1 = {
              pos = "-1080 -254";
              mode = "1920x1080@60Hz";
              transform = "270";
            };
          }
          else {};

        # remove borders of windows
        window.hideEdgeBorders = "both";
        window.border = 1;
        window.titlebar = false;

        # add custom keybindings
        keybindings = let
          mod = modifier;
          swaylock = "${pkgs.swaylock}/bin/swaylock";
          swaynag = "${pkgs.sway}/bin/swaynag";
          pactl = "pactl";
          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
          grim = "${pkgs.grim}/bin/grim";
          slurp = "${pkgs.slurp}/bin/slurp";
          swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
          playerctl = "${pkgs.playerctl}/bin/playerctl";
        in
          lib.mkOptionDefault {
            # lock the screen
            "${mod}+m" = "exec ${swaylock} -c 000000";

            # exit sway
            "${mod}+Shift+e" = "exec ${swaynag} -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

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
            "XF86AudioRaiseVolume" = "exec '${pactl} set-sink-mute 0 false ; ${pactl} set-sink-volume 0 +1%'";
            "XF86AudioLowerVolume" = "exec '${pactl} set-sink-mute 0 false ; ${pactl} set-sink-volume 0 -1%'";
            "XF86AudioMute" = "exec '${pactl} set-sink-mute 0 toggle'";

            # screenshots
            "XF86Explorer" = ''
              ${grim} -g "$(${slurp})" $(xdg-user-dir)/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')
            '';

            # control center
            "${mod}+Shift+n" = "exec ${swaync-client} -t -sw";

            # music control
            "XF86AudioPlay" = "exec ${playerctl} play-pause";
            "XF86AudioPrev" = "exec ${playerctl} previous";
            "XF86AudioNext" = "exec ${playerctl} next";
          };

        # set colors
        colors = lib.mkForce tiling-manager-theme.colors;
      };
    };
  };
}
