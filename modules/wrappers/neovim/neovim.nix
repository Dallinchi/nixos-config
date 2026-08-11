{
  inputs,
  lib,
  self,
  ...
}: {
  flake.nvimWrapper = {
    config,
    wlib,
    lib,
    pkgs,
    ...
  }: let
    selfpkgs = self.packages."${pkgs.system}";
    
    nvim-tcss = pkgs.vimUtils.buildVimPlugin {
      name = "nvim-tcss";
      src = pkgs.fetchFromGitHub {
        owner = "cachebag";
        repo = "nvim-tcss";
        rev = "main";
        hash = "sha256-QHY+UzJrFir/gtj7KDzxvSgFfckG+xwGtd6YyDk81lc="; # lib.fakeHash 
      };
    };

  in {
    imports = [wlib.wrapperModules.neovim];

    config = {
      env.LADSPA_PATH = "${pkgs.deepfilternet}lib/ladspa/libdeep_filter_ladspa.so";
      settings.config_directory = ./.;
      # settings.dont_link = config.binName != "nvim";
      # binName = lib.mkIf config.settings.test_mode (lib.mkDefault "vim");
      # settings.aliases = lib.mkIf (config.binName == "nvim") ["vi"];

      specs.initLua = {
        data = null;
        before = ["MAIN_INIT"];
        config = ''
          require('init')
        '';
      };

      runtimePkgs = [
        pkgs.lua-language-server
        pkgs.nixd

        pkgs.tree-sitter
        pkgs.ripgrep
        pkgs.fd
        pkgs.glib
        pkgs.lazygit
        pkgs.sqlite
        # pkgs.yazi # TODO: Wrapped Yazi
        pkgs.git
      ];

      specs.start = let
        p = pkgs.vimPlugins;
      in [
        p.lz-n
        p.plenary-nvim
        p.nvim-lspconfig
        p.nvim-treesitter.withAllGrammars
        p.which-key-nvim

        # completion
        p.blink-cmp
        p.nvim-web-devicons
        p.comment-nvim
        
        nvim-tcss

        # misc
        p.snacks-nvim
        p.lualine-nvim
        p.yazi-nvim
        p.flash-nvim
        p.alpha-nvim
      ];

      specs.opt = let
        p = pkgs.vimPlugins;
      in {
        lazy = true;
        data = [
          p.lazydev-nvim
          p.gitsigns-nvim
          p.nvim-autopairs
          p.plenary-nvim
        ];
      };
    };
  };

  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      imports = [self.nvimWrapper];
    };
  };
}
