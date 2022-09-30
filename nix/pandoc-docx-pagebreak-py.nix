{ lib, stdenv, fetchFromGitHub, python310Packages, git }:


with python310Packages; buildPythonPackage rec {
  pname = "pandoc-docx-pagebreak-py";
  version = "0.0.2";
  src = pkgs.fetchFromGitHub {
    owner = "pandocker";
    repo = "pandoc-docx-pagebreak-py";
    rev = "c8cddccebb78af75168da000a3d6ac09349bef73";
    sha256 = "HJw/3jXQjZaK124m68l1xFg9bKrAduqlPYkubD29lDQ=";
    leaveDotGit = true;
  };
  propagatedBuildInputs = [ panflute setuptools ];
  nativeBuildInputs = [ git setuptools-scm ];
}
