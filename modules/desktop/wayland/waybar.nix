{...}: {
  # configuration of waybar
  home-manager.users.tim = {
    pkgs,
    tiling-manager-bar-theme,
    ...
  }: {
    programs.waybar = {
      enable = true;

      # waybar is started by sway
      systemd.enable = false;

      settings = [
        {
          layer = "top";
          height = 20;
          modules-center = ["clock"];
          modules-left = [
            "sway/workspaces"
            "sway/mode"
          ];
          modules-right = [
            "network#wifi"
            "cpu"
            "temperature"
            "memory"
            "disk"
            "battery"
            "pulseaudio"
            "tray"
            "custom/notification"
          ];
          "clock" = {
            "format" = "{:%d-%m-%Y %H:%M}";
            "tooltip" = false;
          };
          "pulseaudio" = {
            "scroll-step" = 1;
            "format" = "{volume}% {icon} {format_source}";
            "format-muted" = "🔇 {format_source}";
            "format-source" = "{volume}% ";
            "format-source-muted" = "";
            "format-icons" = {
              "headphones" = "";
              "handsfree" = "🎧";
              "headset" = "🎧";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [" " " " " "];
            };
            "on-click" = "pavucontrol";
          };
          "network" = {
            "interface" = "enp0s25";
            "format" = "✗ 🖧";
            "format-disconnected" = "✗ 🖧";
            "format-linked" = "✗ 🖧";
            "format-ethernet" = "🖧";
            "tooltip-format-ethernet" = "{ipaddr}/{cidr} 🖧";
            "tooltip-format-linked" = "{ifname} (No IP)";
            "interval" = 3;
          };
          "network#wifi" = {
            "interface" = "wlp4s0";
            "format" = "✗ ";
            "format-wifi" = "{signalStrength}%  ";
            "format-disconnected" = " ✗";
            "format-linked" = " ✗";
            "tooltip-format-linked" = "{ifname} (No IP)";
            "tooltip-format-wifi" = " {ipaddr}/{cidr} ({essid} {signalStrength}%) ";
            "interval" = 3;
          };
          "temperature" = {
            "critical-threshold" = 80;
            "format" = "{temperatureC}°C {icon}";
            "format-icons" = [""];
          };
          "cpu" = {
            "format" = "{usage}% ";
            "tooltip" = false;
          };
          "memory" = {
            "format" = "{used:0.1f}GiB ";
            "tooltip-format" = "{percentage}% of {total:0.1f}GiB ";
            "interval" = 1;
          };
          "disk" = {
            "format" = " {free} 🖴";
          };
          "battery" = {
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% ({time}) {icon}";
            "format-charging" = "{capacity}% ({time}) ";
            "format-plugged" = "{capacity}% ";
            "format-icons" = ["" "" "" "" ""];
          };
          "tray" = {
            "spacing" = 10;
          };
          "custom/notification" = {
            "tooltip" = false;
            "format" = "{icon}";
            "format-icons" = {
              "notification" = "<span foreground='red'><sup></sup></span>  ";
              "none" = "  ";
              "dnd-notification" = "<span foreground='red'><sup></sup></span>  ";
              "dnd-none" = "  ";
              "inhibited-notification" = "<span foreground='red'><sup></sup></span>  ";
              "inhibited-none" = "  ";
              "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>  ";
              "dnd-inhibited-none" = "  ";
            };
            "return-type" = "json";
            "exec" = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
            "on-click" = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
            "on-click-right" = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
            "escape" = true;
          };
        }
      ];

      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: DroidSans;
            font-size: 11px;
            font-weight: 600;
            min-height: 0;
        }

        window#waybar {
            background-color: ${tiling-manager-bar-theme.bar-background};

            color: ${tiling-manager-bar-theme.bar-foreground};
            transition-property: background-color;
            transition-duration: .5s;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }


        #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: ${tiling-manager-bar-theme.bar-foreground};
            border: none
        }

        #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
            box-shadow: inherit;
        }

        #workspaces button.focused {
            background-color: ${tiling-manager-bar-theme.label-focused-background};
        }

        #workspaces button.urgent {
            background-color: ${tiling-manager-bar-theme.label-urgent-background};
        }

        #mode {
            /* background-color: #64727D; */
            background-color: ${tiling-manager-bar-theme.label-mode-background};
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #temperature,
        #network,
        #pulseaudio,
        #tray,
        #mode,
        #disk
        #custom-notification {
            padding: 0 10px;
            margin: 0 4px;
            color:  ${tiling-manager-bar-theme.text};
        }
        #clock {
            font-size: 12px;
            border-bottom: 2px solid ${tiling-manager-bar-theme.date};
        }

        #battery {
            border-bottom: 2px solid ${tiling-manager-bar-theme.battery};
        }

        #battery.charging {
            color: ${tiling-manager-bar-theme.battery-charging};
            border-bottom: 2px solid ${tiling-manager-bar-theme.battery-charging};
        }

        @keyframes blink {
            to {
                background-color: #ffffff;
                color: #000000;
            }
        }

        #battery.critical:not(.charging) {
            background-color: #f53c3c;
            border-bottom: 2px solid #f53c3c;
            color: #ffffff;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #disk {
            color: ${tiling-manager-bar-theme.text};
            border-bottom: 2px solid ${tiling-manager-bar-theme.filesystem};
        }

        #cpu {
            border-bottom: 2px solid ${tiling-manager-bar-theme.cpu};
        }

        #memory {
            border-bottom: 2px solid ${tiling-manager-bar-theme.memory};
        }

        #network.disconnected {
            background-color: ${tiling-manager-bar-theme.network-disconnected};
        }

        #network.linked {
            background-color: ${tiling-manager-bar-theme.network-connected};
        }

        #network.ethernet {
            border-bottom: 2px solid ${tiling-manager-bar-theme.network-connected};
        }

        #network.wifi {
            border-bottom: 2px solid ${tiling-manager-bar-theme.network-connected};
        }

        #pulseaudio {
            border-bottom: 2px solid ${tiling-manager-bar-theme.sound};
        }

        #pulseaudio.muted {
            background-color:${tiling-manager-bar-theme.sound-muted};
        }

        #temperature {
            border-bottom: 2px solid ${tiling-manager-bar-theme.temperature};
        }

        #temperature.critical {
            background-color: ${tiling-manager-bar-theme.temperature-overheat};
            border-bottom: 2px solid ${tiling-manager-bar-theme.temperature-overheat};
        }

        #custom-notification {
          font-family: "NotoSansMono Nerd Font";
        }
      '';
    };
  };
}
