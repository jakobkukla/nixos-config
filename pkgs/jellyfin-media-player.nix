self: super: {
  jellyfin-media-player = super.jellyfin-media-player.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        (super.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/jellyfin/jellyfin-media-player/pull/456.patch";
          sha256 = "2umB/+gapXnsfnlqRapjv4E839lhB7A/lGm6+MakRVo=";
        })
      ];
  });
}
