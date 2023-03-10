{
  description = "My Completely Inelegant Neovim Flake";

  inputs = { nixpkgs.url = "nixpkgs/nixos-22.11"; };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # This is where I import any custom packages that I want to install. By
        # placing them in the overlay the become available in 'pkgs' further
        # below.
        overlays = [
          (self: super: {
            # Kept having issues with ones in stable and unstable so built custom revision
            vale = super.callPackage ./nix/vale.nix { };
            # Wasn't packaged
            flake8-isort =
              super.python3Packages.callPackage ./nix/flake8-isort.nix { };
            # Python with linting and such
            mypython = super.python3Packages.callPackage ./nix/mypython.nix { };
            # Wasn't packaged
            vim-angry-reviewer =
              super.callPackage ./nix/vim-angry-reviewer.nix { };
          })
        ];
      };
    in rec {
      # For nix < 2.7
      # For nix >= 2.7 they should grab automatically from:
      #     apps.${system}.default
      #     packages.${system}.default
      defaultApp.${system} = apps.${system}.default;
      defaultPackage.${system} = packages.${system}.default;

      apps.${system} = rec {
        nvim = {
          type = "app";
          program = "${packages.${system}.default}/bin/nvim";
        };
        default = nvim;
      };
      packages.${system} = with pkgs;
        let
          # My custom neovim with my init file and all the plugins I use.
          myneovim = (neovim.override {
            configure = {
              # customRC expects vimscript but I've already converted to lua
              customRC = ''
                lua << EOF
                ${pkgs.lib.readFile ./init.lua}
                EOF
              '';
              packages.myPlugins = with vimPlugins; {
                start = [
                  # Colorscheme
                  molokai

                  # Syntax coloring
                  nvim-ts-rainbow
                  (nvim-treesitter.withPlugins
                    (plugins: tree-sitter.allGrammars))

                  # Autocompletes
                  nvim-lspconfig
                  nvim-cmp
                  cmp-nvim-lsp

                  # File navigation
                  lf-vim
                  vim-floaterm

                  # The rest
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
                ];
              };
            };
          });
        in rec {
          default = neovimEB;
          # symlinkJoin might not be the best solution here but it worked so I
          # just use it for now.
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
                ]
              }
              makeWrapper ${myneovim}/bin/nvim $out/bin/nvim --prefix PATH : $BINPATH
            '';
          };
        };
    };
}
