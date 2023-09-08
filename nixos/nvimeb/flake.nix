{
  description = "My Completely Inelegant Neovim Flake";

  inputs = { nixpkgs.url = "nixpkgs/nixos-22.11"; };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (self: super: {
            # Kept having issues with ones in stable and unstable so built custom revision
            vale = super.callPackage ./nix/vale.nix { };
            # click and black customized here to use an older version of black that supports targeting 2.7
            click804 = super.python3Packages.callPackage ./nix/click.nix { };
            myblack = super.python3Packages.callPackage ./nix/black.nix { };
            mypython = super.python3Packages.callPackage ./nix/mypython.nix { };
            vim-angry-reviewer =
              super.callPackage ./nix/vim-angry-reviewer.nix { };
            flake8-isort =
              super.python3Packages.callPackage ./nix/flake8-isort.nix { };
          })
        ];
      };
    in rec {
      apps.${system} = rec {
        nvim = {
          type = "app";
          program = "${packages.${system}.default}/bin/nvim";
        };
        default = nvim;
      };
      packages.${system} = with pkgs;
        let
          myneovim = (neovim.override {
            configure = {
              customRC = ''
                lua << EOF
                ${pkgs.lib.readFile ./init.lua}
                EOF
              '';
              packages.myPlugins = with vimPlugins; {
                start = [
                  molokai

                  nvim-ts-rainbow
                  (nvim-treesitter.withPlugins
                    (plugins: tree-sitter.allGrammars))

                  nvim-lspconfig
                  nvim-cmp
                  cmp-nvim-lsp

                  lf-vim
                  vim-floaterm

                  vim-commentary
                  vim-surround
                  vim-repeat
                  fzf-vim
                  vim-argwrap
                  vim-fugitive
                  indent-blankline-nvim
                  camelcasemotion
                  hop-nvim
                  ale
                  goyo-vim
                  vim-oscyank
                  ack-vim
                  vim-angry-reviewer
                  LanguageTool-nvim
                  vim-tmux-clipboard
                ];
              };
            };
          });
        in rec {
          default = neovimEB;
          neovimEB = symlinkJoin {
            name = "neovim";
            paths = [ myneovim ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = with pkgs; ''
              rm $out/bin/nvim
              BINPATH=${
                lib.makeBinPath [
                  gcc
                  nodejs
                  mypython
                  pyright
                  vale
                  tree-sitter
                  nodePackages.bash-language-server
                  shellcheck
                  hadolint
                  nixfmt
                  languagetool
                  rustfmt
                  rust-analyzer
                  cargo
                  rustc
                ]
              }
              makeWrapper ${myneovim}/bin/nvim $out/bin/nvim --prefix PATH : $BINPATH
            '';
          };
        };
    };
}
