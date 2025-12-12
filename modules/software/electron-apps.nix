{
  pkgs,
  self,
  ...
}: {
  # add all electron apps
  environment.systemPackages = with pkgs; [
    # messaging
    discord
  ];

  # wrap all executables to always pass parameters for enabling wayland
  nixpkgs.overlays = [
    # NOTE: if needed this overlay could be reused for other electron apps
    (final: prev: {
      discord = prev.discord.overrideAttrs (old: {
        #nativeBuildInputs = (old.nativeBuildInputs or []) ++ [self.makeWrapper];
        postFixup =
          (old.postFixup or "")
          + ''
            wrapProgram $out/bin/discord \
              --add-flags "--enable-features=UseOzonePlatform" \
              --add-flags "--ozone-platform=wayland"
          '';
      });
    })
  ];
}
