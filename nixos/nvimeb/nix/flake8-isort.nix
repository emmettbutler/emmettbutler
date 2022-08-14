{ buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "flake8-isort";
  version = "4.1.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "Ez+3qCR5ssvbflCg58QccK4TbbjLgjl79kBhOoetb5o=";
  };
  checkInputs = with python3Packages; [ flake8 isort pytest ];
}
