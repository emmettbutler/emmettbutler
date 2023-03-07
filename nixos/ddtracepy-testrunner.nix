{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.python310
    pkgs.python310Packages.pip
    pkgs.python310Packages.virtualenv
    pkgs.python310Packages.cython
    pkgs.gcc
  ];
  shellHook = ''
    python -m virtualenv .venv
    source .venv/bin/activate
    sudo .venv/bin/pip install -e .
    sudo .venv/bin/python setup.py develop
    if [[ -f ../riot/setup.py ]]; then
        echo "Using local riot"
        PREV_DIR=`pwd`
        cd ../riot
        sudo $PREV_DIR/.venv/bin/python setup.py develop
        cd $PREV_DIR
    else
        echo "Using riot from pypi"
        sudo .venv/bin/pip install riot
    fi
  '';
}

