{ buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "flake8-isort";
  version = "5.0.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "CVE5jDQ8Z/STNAetu/tJXU33wDhlDF0FdToAbvz+s5A=";
  };
  checkInputs = with python3Packages; [ flake8 isort pytest ];
}
