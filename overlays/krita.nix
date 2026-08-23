final: prev: {
  tmp-krita-unwrapped = prev.krita-unwrapped.overrideAttrs (p: {
    version = "6.0.3";
    src = final.fetchurl {
      url = "mirror://kde/stable/krita/6.0.3/krita-6.0.3.tar.gz";
      hash = "sha256-Bjl5l6O2cA1RZwaNwPUMw1bYIBhhHtNwh6FWZ5C3Iag=";
    };
  });
}
