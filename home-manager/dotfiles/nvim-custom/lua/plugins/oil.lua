return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function()
	  require("oil").setup({
		  use_default_keymaps = false,
		  keymaps = {
			  ["g?"] = { "actions.show_help", mode = "n" },
			  ["<CR>"] = "actions.select",
			  -- this conflicts with my nav binds
			  -- ["<C-s>"] = { "actions.select", opts = { vertical = true } },
			  -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
			  -- ["<C-t>"] = { "actions.select", opts = { tab = true } },
			  -- ["<C-l>"] = "actions.refresh",
			  ["<C-p>"] = "actions.preview",
			  ["<C-c>"] = { "actions.close", mode = "n" },
			  ["-"] = { "actions.parent", mode = "n" },
			  ["_"] = { "actions.open_cwd", mode = "n" },
			  ["`"] = { "actions.cd", mode = "n" },
			  ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			  ["gs"] = { "actions.change_sort", mode = "n" },
			  ["gx"] = "actions.open_external",
			  ["g."] = { "actions.toggle_hidden", mode = "n" },
			  ["g\\"] = { "actions.toggle_trash", mode = "n" },
		  },
	})

  end
}
