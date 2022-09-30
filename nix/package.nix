{ lib, stdenv, fetchFromGitHub, buildDartPackage, makeWrapper, pandoc, pandoc-docx-pagebreak-py }:

buildDartPackage rec {
  pname = "lang-to-docx";
  version = "0.0.1";

  src = ../.;
  specFile = ../pubspec.yaml;
  lockFile = ../pub2nix.lock;

  nativeBuildInputs = [ makeWrapper ];
  
  postFixup = ''
    wrapProgram $out/bin/langtodocx --suffix PATH : ${lib.makeBinPath [ pandoc pandoc-docx-pagebreak-py ]}
  '';

  meta = with lib; {
    description = "Turns one or multiple files into a single docx file with syntax highlighting.";
    homepage = "https://github.com/FlafyDev/lang-to-docx";
    maintainers = [ ];
    license = licenses.mit;
  };
}
