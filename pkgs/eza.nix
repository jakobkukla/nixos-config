# TODO: remove once https://github.com/eza-community/eza/pull/1037 is merged and packaged
self: super: {
  eza = super.eza.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        (super.fetchpatch {
          url = "https://github.com/eza-community/eza/commit/30d78ba5ce7fd2aabae174bcac106d6b202c6d31.patch";
          sha256 = "sha256-AF2NSKF2TIOWloIvHJz7NssTwx1hN9X/Z+s91Qjub+Y=";
        })
      ];
  });
}
