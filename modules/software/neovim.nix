{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  environment.systemPackages = with pkgs; [
    alejandra
  ];

  # configuration of neovim
  # this does not use home manager, such that this can be used to edit config
  # files as root
  programs.nixvim = {
    enable = true;

    # colorscheme
    extraPlugins = with pkgs.vimPlugins; [
      vim-colorschemes
    ];
    colorscheme = "wombat256i";

    # bottom line
    plugins.lualine.enable = true;

    # basic options
    opts = {
      number = true;
      cursorline = true;
      autochdir = true;
      hidden = true;
      termguicolors = true;
      autoread = true;
      mouse = "a";
      # switch from tabs to spaces
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
    };

    # lsp support
    plugins.lsp = {
      enable = true;
      servers = {
        # nix
        nixd = {
          enable = true;
          settings = {
            formatting = {
              command = ["${pkgs.alejandra}/bin/alejandra"];
            };
          };
        };

        # rust
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
      };
    };

    # autocompletion
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];

        mapping = {
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Down>" = "cmp.mapping.select_next_item()";
          "<Up>" = "cmp.mapping.select_prev_item()";
        };
      };
    };
  };
}
