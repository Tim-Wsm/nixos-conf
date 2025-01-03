{...}: {
  # configuration of waybar
  home-manager.users.tim = {
    pkgs,
    tiling-manager-bar-theme,
    hostname,
    ...
  }: {
    programs.waybar = {
      enable = true;

      # waybar is started by sway
      systemd.enable = false;

      settings = let
        interface =
          if hostname == "tim-pc"
          then "enp6s0"
          else if hostname == "tim-laptop"
          then "wlp4s0"
          else "";
        waybar-music-status = pkgs.writeShellScriptBin "waybar-music-status" ''
            if [[ $(playerctl status) == "Playing" ]]; then
                text="$(playerctl metadata --format '{{ artist }} | {{ title }}   𝅘𝅥𝅮')"
                echo {\"text\": \"$text\", \"class\": \"playing\"}
            elif [[ $(playerctl status) == "Paused" ]]; then 
                text="$(playerctl metadata --format '{{ artist }} | {{ title }}   𝅘𝅥𝅮')"
                echo {\"text\": \"$text\", \"class\": \"paused\"}
            else 
                echo {\"text\": \"\", \"class\": \"disconnected\"}
            fi
        '';
        custom-modules = {
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
            "interface" = "${interface}";
            "format" = "✗ 🖧";
            "format-disconnected" = "✗ 🖧";
            "format-linked" = "✗ 🖧";
            "format-ethernet" = "{ipaddr}/{cidr}  🖧";
            "tooltip-format-ethernet" = "{ipaddr}/{cidr}  🖧";
            "tooltip-format-linked" = "{ifname} (No IP)";
            "interval" = 3;
          };
          "network#wifi" = {
            "interface" = "wlp4s0";
            "format" = "✗ ";
            "format-wifi" = "{ipaddr}/{cidr} {signalStrength}%  ";
            "format-disconnected" = "✗  ";
            "format-linked" = "✗  ";
            "tooltip-format-wifi" = " {ipaddr}/{cidr} ({essid} {signalStrength}%) ";
            "interval" = 3;
          };
          "cpu" = {
            "format" = "{usage}%";
            "tooltip" = false;
          };
          "temperature" = {
            "critical-threshold" = 80;
            "format" = "{temperatureC}°C";
            "hwmon-path" = [
              "/sys/class/hwmon/hwmon2/temp1_input"
              "/sys/class/hwmon/hwmon3/temp1_input"
              "/sys/class/thermal/thermal_zone0/temp"
            ];
          };
          "memory" = {
            "format" = "{used:0.1f}GiB";
            "tooltip-format" = "{percentage}% of {total:0.1f}GiB";
            "interval" = 1;
          };
          "custom/cpu-icon" = {
            "format" = " ";
          };

          "group/cpu-info" = {
            "orientation" = "horizontal";
            "modules" = [
              "cpu"
              "temperature"
              "memory"
              "custom/cpu-icon"
            ];
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

          "custom/gpu-utilization" = {
            "exec" = "nvidia-smi --query-gpu=utilization.gpu --format=csv,nounits,noheader";
            "format" = "{}%";
            "interval" = 2;
          };
          "custom/gpu-temperature" = {
            "exec" = "nvidia-smi --query-gpu=temperature.gpu --format=csv,nounits,noheader";
            "format" = "{}°C";
            "interval" = 2;
          };
          "custom/gpu-memory" = {
            "exec" = ''
              nvidia-smi --query-gpu=memory.used --format=csv,nounits,noheader |  awk '{print $1"Mi"}' | numfmt --from=iec-i --to=iec-i |  awk '{print $1"B"}'
            '';
            "format" = "{}";
            "interval" = 2;
          };
          "custom/gpu-icon" = {
            "format" = "󰢮 ";
          };
          "group/gpu-info" = {
            "orientation" = "horizontal";
            "modules" = [
              "custom/gpu-utilization"
              "custom/gpu-temperature"
              "custom/gpu-memory"
              "custom/gpu-icon"
            ];
          };

        "custom/music" = {
            "exec" = "${waybar-music-status}/bin/waybar-music-status";
            "return-type" = "json";
            "format-disconnected" = "";
            "format-playing" = "{}";
            "format-paused" = "{}";
            "interval" = 1;
          };
        };
        default-bar-layout =
          {
            layer = "top";
            height = 20;
            modules-center = ["clock"];
            modules-left = [
              "sway/workspaces"
              "sway/mode"
            ];
          }
          // custom-modules;
        default-bar =
          default-bar-layout
          // {
            modules-right = [
              "custom/music"
              "network#wifi"
              "group/cpu-info"
              "disk"
              "battery"
              "pulseaudio"
              "tray"
              "custom/notification"
            ];
          };
        main-bar-pc =
          default-bar-layout
          // {
            output = "DP-1";
            modules-right = [
              "custom/music"
              "network"
              "group/cpu-info"
              "group/gpu-info"
              "disk"
              "battery"
              "pulseaudio"
              "tray"
              "custom/notification"
            ];
          };
        secondary-bar-pc =
          default-bar-layout
          // {
            output = "HDMI-A-1";
            modules-right = [
              "custom/music"
              "group/cpu-info"
              "group/gpu-info"
            ];
          };
      in
        if hostname == "tim-pc"
        then [
          main-bar-pc
          secondary-bar-pc
        ]
        else [default-bar];

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

        #workspaces button.visible {
            background-color: ${tiling-manager-bar-theme.label-focused-background};
        }

        #workspaces button.urgent {
            background-color: ${tiling-manager-bar-theme.label-urgent-background};
        }

        #mode {
            background-color: ${tiling-manager-bar-theme.label-mode-background};
        }

        #clock,
        #battery,
        #network,
        #pulseaudio,
        #tray,
        #mode,
        #disk,
        #custom-notification,
        #cpu-info,
        #gpu-info,
        #custom-music
        {
            padding: 0 10px;
            margin: 0 4px;
            color:  ${tiling-manager-bar-theme.text};
        }

        #clock {
            font-size: 12px;
            border-bottom: 2px solid ${tiling-manager-bar-theme.date};
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

        #cpu {
            padding: 0 5px;
        }
        #temperature {
            padding: 0 5px;
        }
        #temperature.critical {
            padding: 0 5px;
            background-color: ${tiling-manager-bar-theme.temperature-overheat};
        }
        #memory {
            padding: 0 5px;
        }
        #custom-cpu-icon{
            padding: 0 5px;
        }
        #cpu-info {
            padding: 0 0px;
            border-bottom: 2px solid ${tiling-manager-bar-theme.cpu};
        }


        #custom-gpu-utilization {
            padding: 0 5px;
        }
        #custom-gpu-temperature {
            padding: 0 5px;
        }
        #custom-gpu-memory {
            padding: 0 5px;
        }
        #custom-gpu-icon {
            padding: 0 5px;
        }
        #gpu-info {
            padding: 0 0px;
            border-bottom: 2px solid ${tiling-manager-bar-theme.gpu};
        }

        #disk {
            color: ${tiling-manager-bar-theme.text};
            border-bottom: 2px solid ${tiling-manager-bar-theme.filesystem};
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

        #pulseaudio {
            border-bottom: 2px solid ${tiling-manager-bar-theme.sound};
        }

        #pulseaudio.muted {
            background-color:${tiling-manager-bar-theme.sound-muted};
        }

        #custom-notification {
          font-family: "NotoSansMono Nerd Font";
        }

        #custom-music {
            border-bottom: 2px solid ${tiling-manager-bar-theme.sound};
        }

        #custom-music.paused {
            background-color:${tiling-manager-bar-theme.sound-muted};
            border-bottom: 2px solid ${tiling-manager-bar-theme.sound};
        }
      '';
    };
  };
}
