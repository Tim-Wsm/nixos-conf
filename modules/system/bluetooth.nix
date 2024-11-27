{pkgs, ...}: {
  # dependencies for bluetooth
  environment.systemPackages = with pkgs; [
    bluez
    bluez5
    bluez-tools
    bluez-alsa
  ];

  # enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # enable available bluetooth audio codecs
  services.pipewire.wireplumber.extraConfig."10-bluez" = {
    "monitor.bluez.properties" = {
      "bluez5.enable" = true;
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-faststream" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.codecs" = [
        "sbc"
        "sbc_xq"
        "aac"
        "ldac"
        "aptx"
        "aptx_hd"
        "aptx_ll"
        "aptx_ll_duplex"
        "faststream"
        "faststream_duplex"
      ];
      "bluez5.roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
        "a2dp_sink"
        "a2dp_source"
      ];
    };
  };

  # disable automatic switch to headset mode
  services.pipewire.wireplumber.extraConfig."11-bluetooth-policy" = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
  };

  # set bitrate for Sennheiser "Sport True Wireless" to prevent lags
  services.pipewire.wireplumber.extraConfig."99-Sennheiser-Sport-True-Wireless-aac-bitratemode" = {
    "monitor.bluez.rules" = [
      {
        matches = [
          {
            # only match the Sennheiser "Sport True Wireless"
            "device.name" = "bluez_card.80_C3_BA_09_E7_E5";
          }
        ];

        actions = {
          update-props = {
            # Set the aac bitrate quality to 3 out of 1-5. The default (0)
            # constant rate causes significant lags roughly every 10 seconds.
            # Bitrate modes 5 - 3 reduce the occurance of lags. Bitrate mode
            # 2 seems to work fine.
            "bluez5.a2dp.aac.bitratemode" = 2;
          };
        };
      }
    ];
  };
}
