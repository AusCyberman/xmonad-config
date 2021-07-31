{
  description = "my xmonad configuration";
  inputs = {
    xmonad = {
      url = "github:auscyberman/xmonad";
      flake = false;
    };
    xmonad-contrib = {
      #            url = "github:auscyberman/xmonad-contrib";
      #url = "/home/auscyber/xmonad-contrib";
      url = "github:xmonad/xmonad-contrib";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = { nixpkgs, xmonad, xmonad-contrib, flake-utils, ... }:
  let 
        haskellOverlay = final: prev: {
          haskellPackages = prev.haskellPackages.override {
            overrides = self: super: {
              #ghc = prev.haskell.compiler.ghc901;
#              X11 = self.X11_1_10;
              xmonad = self.callCabal2nix "xmonad" xmonad { };
              xmonad-contrib =
                self.callCabal2nix "xmonad-contrib" xmonad-contrib { };
              my-xmonad = self.callCabal2nix "my-xmonad" (./.) { };

            };
          };
          my-xmonad = final.my-xmonad;

        };
  in
    flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ haskellOverlay ];
        };
      in
      {
        defaultPackage = pkgs.haskellPackages.my-xmonad;
        packages = {
          inherit (pkgs.haskellPackages) my-xmonad xmonad xmonad-contrib;
        };

      }) // {
        overlay = haskellOverlay;
      };
}
