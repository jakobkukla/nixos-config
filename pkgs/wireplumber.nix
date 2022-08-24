self: super:
{
  wireplumber = super.wireplumber.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (super.fetchpatch {
        url = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/merge_requests/398.patch";
        sha256 = "rEp/3fjBRbkFuw4rBW6h8O5hcy/oBP3DW7bPu5rVfNY=";
      })
    ];
  });
}

