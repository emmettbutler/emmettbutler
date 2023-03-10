{ python2 }:

let
  my-python-packages = python-packages: with python-packages; [ black ];
  mypython2 = python2.withPackages my-python-packages;
in mypython2
