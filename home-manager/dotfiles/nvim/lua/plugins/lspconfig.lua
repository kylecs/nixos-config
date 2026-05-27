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
        lua = { "stylua" },
        -- Use deno fmt in Deno projects; condition prevents it running on Node projects
        typescript = {
          {
            name = "deno_fmt",
            condition = function(ctx)
              return vim.fs.find({ "deno.json", "deno.jsonc" }, { path = ctx.filename, upward = true })[1] ~= nil
            end,
          },
        },
        javascript = {
          {
            name = "deno_fmt",
            condition = function(ctx)
              return vim.fs.find({ "deno.json", "deno.jsonc" }, { path = ctx.filename, upward = true })[1] ~= nil
            end,
          },
        },
        typescriptreact = {
          {
            name = "deno_fmt",
            condition = function(ctx)
              return vim.fs.find({ "deno.json", "deno.jsonc" }, { path = ctx.filename, upward = true })[1] ~= nil
            end,
          },
        },
        javascriptreact = {
          {
            name = "deno_fmt",
            condition = function(ctx)
              return vim.fs.find({ "deno.json", "deno.jsonc" }, { path = ctx.filename, upward = true })[1] ~= nil
            end,
          },
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
        rust_analyzer = {
          mason = false,
          settings = {
            Nix = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        wgsl_analyzer = {
          mason = false,
          settings = {
            Nix = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        -- Deno LSP: activates on projects with deno.json / deno.jsonc
        denols = {
          mason = false,
          root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc"),
        },
        -- Node/TypeScript LSP: activates on projects with package.json only (no deno.json)
        ts_ls = {
          mason = false,
          root_dir = require("lspconfig.util").root_pattern("package.json"),
          single_file_support = false,
        },
        -- Java configured in jdtls.lua
      },
    },
  },
}
