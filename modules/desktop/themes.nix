{
  pkgs,
  config,
  ...
}: {
  # configures stylix

  stylix = {
    enable = true;

    # set wallpaper
    image = pkgs.fetchurl {
      url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-binary-black_8k.png?raw=true";
      sha256 = "MxEgvzWmdqMeI5GeI6Hzci6yd5iL44NDXyKQOuw+fLY=";
    };

    # prefere dark mode
    polarity = "dark";

    # set base16 color scheme
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  };

  # defines the common theme used by i3 and sway
  home-manager.extraSpecialArgs = {
    tiling-manager-bar-theme = {
      # bar colors
      bar-background = "#${config.lib.stylix.colors.base00}";
      bar-foreground = "#${config.lib.stylix.colors.base07}";

      # workspaces
      label-mode-background = "#${config.lib.stylix.colors.base09}";
      label-mode-underline = "#${config.lib.stylix.colors.base09}";
      label-focused-background = "#${config.lib.stylix.colors.base03}";
      label-focused-underline = "#${config.lib.stylix.colors.base03}";
      label-unfocused-background = "#${config.lib.stylix.colors.base00}";
      label-unfocused-underline = "#${config.lib.stylix.colors.base00}";
      label-visible-background = "#${config.lib.stylix.colors.base03}";
      label-visible-underline = "#${config.lib.stylix.colors.base02}";
      label-urgent-background = "#${config.lib.stylix.colors.base08}";
      label-urgent-underline = "#${config.lib.stylix.colors.base08}";

      # module colors
      text = "#${config.lib.stylix.colors.base07}";
      date = "#${config.lib.stylix.colors.base09}";
      network-connected = "#${config.lib.stylix.colors.base0B}";
      network-disconnected = "#${config.lib.stylix.colors.base0A}";
      cpu = "#${config.lib.stylix.colors.base08}";
      temperature = "#${config.lib.stylix.colors.base0D}";
      temperature-overheat = "#${config.lib.stylix.colors.base08}";
      memory = "#${config.lib.stylix.colors.base0A}";
      filesystem = "#${config.lib.stylix.colors.base0E}";
      sound = "#${config.lib.stylix.colors.base0F}";
      sound-muted = "#${config.lib.stylix.colors.base04}";
      battery = "#${config.lib.stylix.colors.base06}";
      battery-charging = "#${config.lib.stylix.colors.base0A}";
    };
    tiling-manager-theme = {
      colors = let
        theme = {
          text = "#${config.lib.stylix.colors.base07}";
          border = "#${config.lib.stylix.colors.base02}";
          childBorder = "#${config.lib.stylix.colors.base02}";
          background-focused = "#${config.lib.stylix.colors.base03}";
          text-unfocused = "#${config.lib.stylix.colors.base03}";
          background-unfocused = "#${config.lib.stylix.colors.base01}";
          indicator = "#${config.lib.stylix.colors.base08}";
          urgent = "#${config.lib.stylix.colors.base08}";
          placeholder = "#000000"; # black
        };
      in {
        focused = {
          border = "${theme.border}";
          background = "${theme.background-focused}";
          text = "${theme.text}";
          indicator = "${theme.indicator}";
          childBorder = "${theme.childBorder}";
        };
        focusedInactive = {
          border = "${theme.border}";
          background = "${theme.background-unfocused}";
          text = "${theme.text-unfocused}";
          indicator = "${theme.indicator}";
          childBorder = "${theme.childBorder}";
        };
        unfocused = {
          border = "${theme.border}";
          background = "${theme.background-unfocused}";
          text = "${theme.text-unfocused}";
          indicator = "${theme.indicator}";
          childBorder = "${theme.childBorder}";
        };
        urgent = {
          border = "${theme.urgent}";
          background = "${theme.urgent}";
          text = "${theme.text}";
          indicator = "${theme.urgent}";
          childBorder = "${theme.urgent}";
        };
        placeholder = {
          border = "${theme.placeholder}";
          background = "${theme.placeholder}";
          text = "${theme.text}";
          indicator = "${theme.placeholder}";
          childBorder = "${theme.placeholder}";
        };
      };
    };
  };
}
