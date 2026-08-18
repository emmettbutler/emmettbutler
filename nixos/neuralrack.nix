{ pkgs, ... }:

let
  neuralrackUnwrapped = pkgs.stdenv.mkDerivation {
    pname = "neuralrack-unwrapped";
    version = "0.4.1";
    src = pkgs.fetchurl {
      url =
        "https://github.com/brummer10/NeuralRack/releases/download/v0.4.1/NeuralRack-app-v0.4.1-linux-x86_64.tar.xz";
      hash = "sha256-KAhmynCVqKUrQK/1Y+JdhaGtNac8mW87yOE7sdoG+vQ=";
    };
    sourceRoot = ".";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      install -m755 NeuralRack-app-v0.4.1/Neuralrack $out/bin/Neuralrack
    '';
  };
  neuralrack = pkgs.buildFHSEnv {
    name = "neuralrack";
    targetPkgs = pkgs: [ neuralrackUnwrapped pkgs.libsndfile pkgs.alsa-lib ];
    runScript = "${neuralrackUnwrapped}/bin/Neuralrack";
  };
  neuralrackDesktopItem = pkgs.makeDesktopItem {
    name = "neuralrack";
    desktopName = "NeuralRack";
    comment = "Neural network guitar amp and cabinet modeler";
    exec = "neuralrack";
    icon = "audio-x-generic";
    categories = [ "Audio" "AudioVideo" ];
    terminal = false;
  };
in { environment.systemPackages = [ neuralrack neuralrackDesktopItem ]; }
