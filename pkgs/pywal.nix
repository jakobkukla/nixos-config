self: super:
{
  pywal = super.pywal.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (super.fetchpatch {
        url = "https://github.com/dylanaraps/pywal/commit/0d12a2ca2887010e6db60a8eaa156310f302e473.patch";
        sha256 = "0xqp2wsa88pzrv074s8sl42xk6acli3vf2k7m8rhri2p0bmaqxhg";
      })
    ];
  });
}

