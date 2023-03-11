{ buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "black";
  version = "21.4b2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "/JvPO0grBcHzX2qILAedwBucd5WCdTL0zEPA7IgGe7w=";
  };
  checkInputs = with python3Packages; [
    setuptools_scm
    regex
    pathspec
    mypy-extensions
    toml
    appdirs
    click
  ];
}
