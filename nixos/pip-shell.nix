{ pkgs ? import <nixpkgs> { } }:
(pkgs.buildFHSUserEnv {
  name = "pipzone";
  targetPkgs = pkgs:
    (with pkgs; [
      gcc
      python39
      python39Packages.pip
      python39Packages.virtualenv
      postgresql
      openjdk8
    ]);
  runScript = "bash";
}).env
