{ buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "flake8-isort";
  version = "4.2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "JlcVAM1Ul2u8DPEAb/vNGmjdEC+Ba3oQUbIZYWup/uA=";
  };
  checkInputs = with python3Packages; [ flake8 isort pytest ];
}
