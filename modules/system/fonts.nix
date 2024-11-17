{
  pkgs,
  config,
  ...
}: {
  # installs some basic fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerdfonts
  ];

  # configure fonts via stylix
  stylix.fonts = {
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };

    serif = config.stylix.fonts.sansSerif;

    monospace = {
      package = pkgs.noto-fonts;
      name = "Noto Sans Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      terminal = 9;
      applications = 10;
      desktop = 9;
      popups = 10;
    };
  };
}
