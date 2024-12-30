{pkgs, ...}: {
  # configuration of sway notification client
  home-manager.users.tim = {...}: {
    home.file.".config/swaync/config.json".text = let
      sway-screenshot = pkgs.writeShellScriptBin "sway-screenshot" ''
        ${pkgs.swaynotificationcenter}/bin/swaync-client -cp
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | wl-copy
      '';
    in ''
      {
        "positionX": "right",
        "positionY": "top",
        "layer": "overlay",
        "control-center-layer": "top",
        "layer-shell": true,
        "cssPriority": "application",
        "control-center-margin-top": 0,
        "control-center-margin-bottom": 0,
        "control-center-margin-right": 0,
        "control-center-margin-left": 0,
        "notification-2fa-action": true,
        "notification-inline-replies": false,
        "notification-icon-size": 64,
        "notification-body-image-height": 100,
        "notification-body-image-width": 200,
        "timeout": 10,
        "timeout-low": 5,
        "timeout-critical": 0,
        "fit-to-screen": true,
        "relative-timestamps": true,
        "control-center-width": 500,
        "control-center-height": 600,
        "notification-window-width": 500,
        "keyboard-shortcuts": true,
        "image-visibility": "when-available",
        "transition-time": 200,
        "hide-on-clear": false,
        "hide-on-action": true,
        "script-fail-notify": true,
        "scripts": {
          "example-script": {
            "exec": "echo 'Do something...'",
            "urgency": "Normal"
          },
          "example-action-script": {
            "exec": "echo 'Do something actionable!'",
            "urgency": "Normal",
            "run-on": "action"
          }
        },
        "notification-visibility": {
          "example-name": {
            "state": "muted",
            "urgency": "Low",
            "app-name": "Spotify"
          }
        },
        "widgets": [
          "inhibitors",
          "buttons-grid",
          "mpris",
          "volume",
          "menubar",
          "title",
          "dnd",
          "notifications"
        ],
        "widget-config": {
          "inhibitors": {
            "text": "Inhibitors",
            "button-text": "Clear All",
            "clear-all-button": true
          },
          "title": {
            "text": "Notifications",
            "clear-all-button": true,
            "button-text": "Clear All"
          },
          "dnd": {
            "text": "Do Not Disturb"
          },
          "label": {
            "max-lines": 5,
            "text": "Label Text"
          },
          "mpris": {
            "image-size": 96,
            "image-radius": 12
          },
          "buttons-grid": {
            "actions": [
                {
                    "label": "🌐",
                    "command" : "firefox"
                },
                {
                    "label": "📧",
                    "command" : "thunderbird"
                },
                {
                    "label": "📁",
                    "command": "nautilus"
                },
                {
                    "label": "📷",
                    "command" : "${sway-screenshot}/bin/sway-screenshot"
                }
            ]
          },
          "volume": {
            "label": " "
          },
          "menubar": {
             "menu#power": {
                 "label": "Power Management",
                 "position": "left",
                 "actions": [
                     {
                         "label": "Shutdown",
                         "command": "systemctl poweroff"
                     },
                     {
                         "label": "Reboot",
                         "command": "systemctl reboot"
                     }
                ]
            }
          }
        }
      }
    '';
  };
}
