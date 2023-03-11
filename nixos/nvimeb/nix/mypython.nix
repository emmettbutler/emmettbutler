{ python3, flake8-isort, black }:

let
  my-python-packages = python-packages:
    with python-packages; [
      jedi-language-server
      flake8
      flake8-isort
      isort
      black
    ];
  mypython = python3.withPackages my-python-packages;
in mypython
