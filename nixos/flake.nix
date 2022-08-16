{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    neovimeb.url = "path:/home/emmett/git/emmettbutler/nixos/nvimeb";
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
      # My custom overlay. Make packages for the different available in the
      # same place. Saves from having to pass imports into modules and manually
      # import the packages
      my-custom-overlay = final: prev: rec {
        # Allow unstable packages to allow unfree packages
        unstable = import inputs.nixpkgs-unstable {
          system = "${system}";
          config.allowUnfree = true;
        };
        neovimeb = inputs.neovimeb.packages.${prev.system};
        mypython310 =
          pkgs.python310.withPackages (py-pkgs: with py-pkgs; [ virtualenv requests ipython ]);
      };
    in {
      nixosConfigurations.hell = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          # This makes my custom overlay available for others to use.
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ my-custom-overlay ]; })
          ./configuration.nix
        ];
      };

      devShells.x86_64-linux.python38 = pkgs.mkShell {
        nativeBuildInputs = with pkgs;
          let
            devpython = pkgs.python38.withPackages
              (packages: with packages; [ virtualenv pip setuptools wheel ]);
          in [ devpython postgresql ];
        LD_LIBRARY_PATH =
          "${pkgs.stdenv.cc.cc.lib}/lib/:${pkgs.xmlsec}/lib/:${pkgs.rdkafka}/lib/";
      };

      devShells.x86_64-linux.python39 = pkgs.mkShell {
        nativeBuildInputs = with pkgs;
          let
            devpython = pkgs.python39.withPackages
              (packages: with packages; [ virtualenv pip setuptools wheel ]);
          in [ devpython leiningen jdk8_headless postgresql ];
        LD_LIBRARY_PATH =
          "${pkgs.stdenv.cc.cc.lib}/lib/:${pkgs.xmlsec}/lib/:${pkgs.rdkafka}/lib/";
      };

      devShells.x86_64-linux.ansiform = pkgs.mkShell {
        name = "ansiform";
        nativeBuildInputs = with pkgs;
          let mygoogleauth = aws-google-auth.override { withU2F = true; };
          in [ mygoogleauth ansible ];
      };

    };
}


