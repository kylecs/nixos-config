local java_home = os.getenv("JAVA_HOME")
return {
  {
    "mason-org/mason.nvim",
    -- please please don't install stylua it doesn't work on nixos
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(p)
        return not vim.tbl_contains({ "stylua" }, p)
      end, opts.ensure_installed)
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = {
          "stylua",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        lua_ls = {
          mason = false,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        nil_ls = {
          mason = false,
          settings = {
            Nix = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        -- Java configured in jdtls.lua
      },
    },
  },
}
