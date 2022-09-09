{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-dart.url = "github:Cir0X/nix-dart";
  };

  outputs = { self, nixpkgs, flake-utils, nix-dart, }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system; 
    };
  in {
    devShell = pkgs.mkShell {
      packages = with pkgs; [
        dart
        pandoc
      ];
    };
  }) // {
    overlays.default = final: prev: let 
      nix-dart-pkgs = import nixpkgs { 
        inherit (prev) system;
        overlays = [ nix-dart.overlay ];
      };
    in {
      lang-to-docx = (prev.callPackage ./nix/package.nix {
        buildDartPackage = nix-dart-pkgs.buildDartPackage.override ({
          dart = prev.dart;
        });
      });
    };
  };
}
