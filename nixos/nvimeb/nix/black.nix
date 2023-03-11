{ buildPythonPackage, fetchPypi, python3Packages, myclick }:

buildPythonPackage rec {
  pname = "black";
  version = "21.4b2";
  #version = "19.10b0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "/JvPO0grBcHzX2qILAedwBucd5WCdTL0zEPA7IgGe7w=";
    #sha256 = "wu23Ogjp4Ob2Wg5q8YsFm4sc3VvvmX16Cxgd+T3IFTk=";
  };
  checkInputs = with python3Packages; [
    setuptools_scm
    regex
    pathspec
    mypy-extensions
    toml
    appdirs
    myclick
    typed-ast
    attrs
    aiohttp
    aiohttp-cors
    pytest
    pytest-mock
    pytest-cases
    coverage
    tomli
    typing-extensions
    packaging
    platformdirs
  ];
}
