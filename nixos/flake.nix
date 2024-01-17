{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # https://github.com/NixOS/nix/issues/3978
    neovimeb.url = "path:/home/emmett/git/emmettbutler/nixos/nvimeb";
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
      my-custom-overlay = final: prev: rec {
        unstable = import inputs.nixpkgs-unstable {
          system = "${system}";
          config.allowUnfree = true;
        };
        neovimeb = inputs.neovimeb.packages.${prev.system};
        mypython311 = pkgs.python311.withPackages
          (py-pkgs: with py-pkgs; [ virtualenv requests ipython ]);
      };
    in {
      # for the first run on a fresh system, the hostname is "nixos"
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ my-custom-overlay ]; })
          ./configuration.nix
        ];
      };
      # on subsequent runs, the hostname is "hell"
      nixosConfigurations.hell = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ my-custom-overlay ]; })
          ./configuration.nix
        ];
      };
    };
}

