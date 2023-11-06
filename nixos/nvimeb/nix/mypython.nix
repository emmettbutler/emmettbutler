{ python3, python3Packages }:

let
  my-python-packages = python-packages: with python-packages; [ ruff-lsp ];
  mypython = python3.withPackages my-python-packages;
in mypython
