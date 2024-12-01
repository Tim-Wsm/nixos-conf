{
  pkgs,
  config,
  ...
}: {
  # installs some basic fonts
  fonts.packages = with pkgs; [
    # basic fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    #nerdfonts
    nerd-fonts.symbols-only
    nerd-fonts.noto
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.fira-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.dejavu-sans-mono
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
