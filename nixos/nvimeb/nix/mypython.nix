{ python3, flake8-isort, myblack }:

let
  my-python-packages = python-packages:
    with python-packages; [
      flake8
      flake8-isort
      isort
      myblack
    ];
  mypython = python3.withPackages my-python-packages;
in mypython
