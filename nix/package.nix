{ lib, stdenv, fetchFromGitHub, buildDartPackage, makeWrapper, pandoc }:

buildDartPackage rec {
  pname = "lang-to-docx";
  version = "0.0.1";

  src = ../.;
  specFile = ../pubspec.yaml;
  lockFile = ../pub2nix.lock;

  nativeBuildInputs = [ makeWrapper ];
  
  postFixup = ''
    wrapProgram $out/bin/langtodocx --set PATH ${lib.makeBinPath [ pandoc ]}
  '';

  meta = with lib; {
    description = "Turns one or multiple files into a single docx file with syntax highlighting.";
    homepage = "https://github.com/FlafyDev/lang-to-docx";
    maintainers = [ ];
    license = licenses.mit;
  };
}
