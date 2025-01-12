{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  # dependencies of the neovim configuration
  environment.systemPackages = with pkgs; [
    ripgrep
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

    # buffer line
    plugins.bufferline = {
      enable = true;
      settings.options = {
        numbers = "ordinal";
        sort_by = "id";
      };
    };

    # keybindings not associated with any package
    keymaps = let
      # switch buffers with <ALT>+number
      switch_buffer_keybinds = lib.map (n: {
        action = ''
          <cmd>lua require("bufferline").go_to_buffer(${builtins.toString n},true) <CR>
        '';
        key = "<A-${builtins.toString n}>";
        options = {
          silent = true;
        };
      }) (lib.range 1 9);
    in
      switch_buffer_keybinds
      ++ [];

    # basic options
    opts = {
      number = true;
      cursorline = true;
      autochdir = true;
      hidden = true;
      termguicolors = true;
      autoread = true;
      mouse = "a";
      # switch from tabs to s"minimal"paces
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
    };

    # treesitter support
    plugins.treesitter = {
      enable = true;
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
          installRustfmt = true;
        };

        # ocaml
        ocamllsp = {
          enable = true;
          package = pkgs.ocamlPackages.ocaml-lsp;
        };
      };
    };

    # border for lsp "hover" output
    extraConfigLua = ''
      local _border = "rounded"

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = _border
        }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = _border
        }
      )

      vim.diagnostic.config{
        float={border=_border}
      };

      require('lspconfig.ui.windows').default_options = {
        border = _border
      }

      config = function(_, opts)
        local lspconfig = require('lspconfig')
        for server, config in pairs(opts.servers) do
          -- passing config.capabilities to blink.cmp merges with the capabilities in your
          -- `opts[server].capabilities, if you've defined it
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          lspconfig[server].setup(config)
        end
      end;
    '';

    # format on save
    plugins.lsp-format = {
      enable = true;
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
          {name = "orgmode";}
        ];

        mapping = {
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Down>" = "cmp.mapping.select_next_item()";
          "<Up>" = "cmp.mapping.select_prev_item()";
        };
      };
    };

    # enable telescope (fuzzy search)
    plugins.web-devicons.enable = true; # dependency of telescope
    plugins.telescope = {
      enable = true;

      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fh" = "help_tags";
      };
    };

    # enable snacks (plugin collection)
    plugins.snacks = {
      enable = true;
      settings = {
        # enable support for big files
        bigfile.enable = true;
        # enable notifications (message box)
        notifier = {
          enable = true;
          timeout = 3000;
          top_down = false; # places message box on bottom right
          style = "minimal";
          margin = {
            top = 0;
            right = 1;
            bottom = 1;
          };
        };
        # enable indentation highlighting (without animations)
        indent = {
          enable = true;
          only_scope = true;
          only_current = true;
          animate.enabled = false;
        };
        # enable highlighted words
        words = {
          enable = true;
          debounce = 0;
        };
      };
    };

    # # enable orgmode plugin
    plugins.orgmode = {
      enable = true;
    };
  };
}
