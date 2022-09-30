{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-dart.url = "github:Cir0X/nix-dart";
  };

  outputs = { self, nixpkgs, ...}@inputs: inputs.flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system; 
    };
  in {
    devShell = pkgs.mkShell (let 
      pandoc-docx-pagebreak-py = pkgs.callPackage ./nix/pandoc-docx-pagebreak-py.nix { };
    in {
      packages = with pkgs; [
        dart
        pandoc
        pandoc-docx-pagebreak-py
      ];
    });
  }) // {
    overlays.default = final: prev: let 
      nix-dart-pkgs = import nixpkgs { 
        inherit (prev) system;
        overlays = [ inputs.nix-dart.overlay ];
      };
      pandoc-docx-pagebreak-py = prev.callPackage ./nix/pandoc-docx-pagebreak-py.nix { };
    in {
      lang-to-docx = (prev.callPackage ./nix/package.nix {
        inherit pandoc-docx-pagebreak-py;
        buildDartPackage = nix-dart-pkgs.buildDartPackage.override ({
          dart = prev.dart;
        });
      });
    };
  };
}
