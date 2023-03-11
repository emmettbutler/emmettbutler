{ buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "click";
  version = "8.0.4";
  src = fetchPypi {
    inherit pname version;
    sha256 = "hFjXsSh8X7EoyQ4jOBz5nc3nS+r2x/9jhM6E1v4JCts=";
  };
  checkInputs = with python3Packages; [ ];
}

