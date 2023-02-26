{ pkgs ? import <nixpkgs> { } }:
(pkgs.buildFHSUserEnv {
  name = "pipzone";
  targetPkgs = pkgs:
    (with pkgs; [
      binutils.bintools
      gcc
      git
      openssh
      python39
      python39Packages.pip
      python39Packages.virtualenv
    ]);
  runScript = "bash";
}).env
