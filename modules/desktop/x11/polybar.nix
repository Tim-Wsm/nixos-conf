{
  config,
  lib,
  ...
}: {
  # Explicitely removes the polybar.service systemd service. The bar is started
  # by i3 on each startup.
  systemd.services.polybar = {
    enable = lib.mkForce false;
  };

  # configuration of polybar
  home-manager.users.tim = {
    pkgs,
    tiling-manager-bar-theme,
    hostname,
    ...
  }: {
    services.polybar = {
      enable = true;

      # The startup script is empty, since polybar is started by i3.
      script = '''';

      package = pkgs.polybar.override {
        pulseSupport = true;
        i3Support = true;
      };

      config = let
        fonts = {
          font-0 = "${config.stylix.fonts.monospace.name}:Regular:size=8";
          font-1 = "${config.stylix.fonts.monospace.name}:SemiBold:size=8";
          font-2 = "${config.stylix.fonts.monospace.name}:Bold:size=8";
          font-3 = "${config.stylix.fonts.monospace.name}:Italic:size=8";
        };
        interface =
          if hostname == "tim-pc"
          then "enp6s0"
          else if hostname == "tim-laptop"
          then "wlp4s0"
          else "";
        hwmon-path =
          if hostname == "tim-pc"
          then "/sys/class/hwmon/hwmon2/temp1_input"
          else if hostname == "tim-laptop"
          then "/sys/class/thermal/thermal_zone2/temp"
          else "";
      in {
        # bar definition
        "bar/main" =
          fonts
          // {
            monitor = "\${env:MONITOR}";
            enable-ipc = true;
            override-redirect = false;

            bottom = false;
            width = "100%";
            height = "22px";

            background = "${tiling-manager-bar-theme.bar-background}";
            foreground = "${tiling-manager-bar-theme.bar-foreground}";

            line-size = 2;
            separator = " ";

            modules-left = ["workspaces"];
            modules-center = ["date"];
            modules-right = [
              "network"
              "cpu"
              "temperature"
              "memory"
              "filesystem"
              "sound"
              "tray"
            ];
          };

        "bar/secondary" =
          fonts
          // {
            monitor = "\${env:MONITOR}";
            enable-ipc = true;
            override-redirect = false;

            bottom = false;
            width = "100%";
            height = "22px";

            background = "${tiling-manager-bar-theme.bar-background}";
            foreground = "${tiling-manager-bar-theme.bar-foreground}";

            line-size = 2;
            separator = " ";

            modules-left = ["workspaces"];
            modules-center = ["date"];
            modules-right = ["cpu" "temperature" "memory"];
          };

        # module definitions
        "module/workspaces" = {
          type = "internal/i3";

          pin-workspaces = true;
          strip-wsnumbers = true;
          index-sort = true;

          format = "<label-state> <label-mode>";

          # editing mode
          label-mode = "%mode%";
          label-mode-background = "${tiling-manager-bar-theme.label-mode-background}";
          label-mode-underline = "${tiling-manager-bar-theme.label-mode-underline}";
          label-mode-padding = 1;
          label-mode-font = 2;

          # focused workspace
          label-focused = "%index%";
          label-focused-background = "${tiling-manager-bar-theme.label-focused-background}";
          label-focused-underline = "${tiling-manager-bar-theme.label-focused-underline}";
          label-focused-padding = 1;
          label-focused-font = 2;

          # unfocused workspace
          label-unfocused = "%index%";
          label-unfocused-background = "${tiling-manager-bar-theme.label-unfocused-background}";
          label-unfocused-underline = "${tiling-manager-bar-theme.label-unfocused-underline}";
          label-unfocused-padding = 1;
          label-unfocused-font = 2;

          # visible workspace
          label-visible = "%index%";
          label-visible-background = "${tiling-manager-bar-theme.label-visible-background}";
          label-visible-underline = "${tiling-manager-bar-theme.label-visible-underline}";
          label-visible-padding = 1;
          label-visible-font = 2;

          # urgent workspace
          label-urgent = "%index%";
          label-urgent-background = "${tiling-manager-bar-theme.label-urgent-background}";
          label-urgent-underline = "${tiling-manager-bar-theme.label-urgent-underline}";
          label-urgent-padding = 1;
          label-urgent-font = 2;
        };

        "module/date" = {
          type = "internal/date";

          time = "%H:%M";
          time-alt = "%H:%M:%S";
          date = "%Y-%m-%d%";
          date-alt = "%A, %B %d, %Y";

          format = "<label>";

          format-prefix = "";
          format-padding = 1;

          format-underline = "${tiling-manager-bar-theme.date}";
          format-foreground = "${tiling-manager-bar-theme.date}";
          interval = 20;

          label = "%date% %time%";
          label-font = 2;
          label-foreground = "${tiling-manager-bar-theme.text}";
        };

        "module/network" = {
          type = "internal/network";
          interface = "${interface}";

          format-connected = "<label-connected>";
          format-connected-padding = 1;
          format-connected-foreground = "${tiling-manager-bar-theme.network-connected}";
          format-connected-underline = "${tiling-manager-bar-theme.network-connected}";

          format-disconnected-font = 2;
          format-disconnected-padding = 1;
          format-disconnected-foreground = "${tiling-manager-bar-theme.network-disconnected}";
          format-disconnected-underline = "${tiling-manager-bar-theme.network-disconnected}";

          label-connected = "%local_ip% ⇓%downspeed:8% ⇑%upspeed:8%";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = "0.5";
          format = "<label>";
          format-padding = 1;
          format-underline = "${tiling-manager-bar-theme.cpu}";

          format-prefix = "CPU: ";
          format-prefix-foreground = "${tiling-manager-bar-theme.cpu}";

          label = "%percentage%%";
          label-font = 2;
        };

        "module/temperature" = {
          type = "internal/temperature";

          hwmon-path = "${hwmon-path}";

          interval = "0.5";
          format = "<label>";
          format-padding = 1;
          format-underline = "${tiling-manager-bar-theme.temperature}";

          format-prefix = "Temp: ";
          format-prefix-foreground = "${tiling-manager-bar-theme.temperature}";

          format-warn = "<label-warn>";
          format-warn-foreground = "${tiling-manager-bar-theme.temperature-overheat}";

          label = "%temperature-c%";
          label-font = 2;

          label-warn = "%temperature-c%";
          label-warn-font = 2;
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 3;
          format = "<label>";
          format-padding = 1;
          format-underline = "${tiling-manager-bar-theme.memory}";

          format-prefix = "RAM: ";
          format-prefix-foreground = "${tiling-manager-bar-theme.memory}";

          label = "%gb_used:4%";
          label-font = 2;
        };

        "module/filesystem" = {
          type = "internal/fs";

          # mountpoints to display
          mount-0 = "/";

          # time between updates in seconds
          interval = 10;

          # display fixed precision values
          fixed-values = true;

          # spacing between entries
          spacing = 4;

          # formatting
          label-mounted = "%free% / %total%";
          label-mounted-foreground = "${tiling-manager-bar-theme.text}";
          label-mounted-font = 2;

          format-mounted = "Disk: <label-mounted>";
          format-mounted-foreground = "${tiling-manager-bar-theme.filesystem}";
          format-mounted-padding = 1;
          format-mounted-underline = "${tiling-manager-bar-theme.filesystem}";
        };

        "module/sound" = {
          type = "internal/pulseaudio";

          format-volume = "<label-volume>";
          format-volume-padding = 1;
          format-volume-underline = "${tiling-manager-bar-theme.sound}";
          format-volume-prefix = "Volume: ";
          format-volume-prefix-foreground = "${tiling-manager-bar-theme.sound}";

          label-volume = "%percentage%%";
          label-volume-font = 2;

          label-muted = "Volume: %percentage%%";
          label-muted-font = 2;
          label-muted-padding = 1;
          label-muted-foreground = "${tiling-manager-bar-theme.sound-muted}";
          label-muted-underline = "${tiling-manager-bar-theme.sound-muted}";

          click-right = "pavucontrol";
        };

        "module/tray" = {
          type = "internal/tray";

          format-margin = "8px";
          tray-spacing = "8px";
        };
      };
    };
  };
}
