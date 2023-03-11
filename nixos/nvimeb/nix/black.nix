{ buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "black";
  version = "21.4b2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "fc9bcf3b482b05c1f35f6a882c079dc01b9c7795827532f4cc43c0ec88067bbc";
  };
}
