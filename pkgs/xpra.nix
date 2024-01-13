self: super: {
  xpra = super.xpra.overrideAttrs (old: {
    version = "5.0.4";
    src = super.fetchurl {
      url = "https://xpra.org/src/xpra-5.0.4.tar.xz";
      hash = "sha256-oKLC+MgkFii5IitLqf+jxeMWhTSs9TSBq7plmZtKZH0=";
    };
    patches = [];
  });
}
