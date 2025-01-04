{
    nixpkgs.overlays =
    let
        moz-rev = "master";
        moz-url = builtins.fetchTarball { 
            url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz";
            sha256 = "1f41psqw00mdcwm28y1frjhssybg6r8i7rpa8jq0jiannksbj27s";
        };
        nightlyOverlay = (import "${moz-url}/firefox-overlay.nix");
    in [
        nightlyOverlay
    ];
}
