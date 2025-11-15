return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    -- ... other nvim-treesitter options
    highlight = {
      enable = true,
      -- If you had a `disable` list, make sure 'mylanguage' is NOT in it:
      -- disable = { "javascript", "typescript", "lua" },

      -- This option is crucial for traditional Vim syntax files when Tree-sitter is enabled.
      -- Set to `true` to enable traditional Vim regex highlighting alongside Tree-sitter.
      -- Or, you can make it a table of filetypes for which to enable it:
      additional_vim_regex_highlighting = { "smali" }, -- Add your custom filetype here
      -- Or simply `true` if you want it for all files not covered by Tree-sitter:
      -- additional_vim_regex_highlighting = true,
    },
    -- ... other nvim-treesitter options
  },
}
