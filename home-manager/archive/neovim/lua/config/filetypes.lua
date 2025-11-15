
-- Add an autocmd to set the filetype based on the extension
vim.filetype.add({
  extension = {
    myext = "smali", -- Replace 'myext' with your actual file extension (e.g., 'foo', 'conf')
  },
  -- You can also detect by filename if there's no extension:
  -- filename = {
  --   ["MySpecificFileName"] = "mylanguage",
  -- },
  -- Or by a pattern (e.g., path):
  -- pattern = {
  --   [".*/myproject/.*%.cfg"] = "mylanguage",
  -- },
})

-- It's often good practice to ensure syntax highlighting is enabled.
-- LazyVim usually handles this, but if you find it's not, you can explicitly
-- ensure it's on for your filetype.
vim.api.nvim_create_autocmd("smali", {
  pattern = "smali", -- Use the filetype you just set
  callback = function()
    vim.cmd("syntax on") -- Ensure syntax highlighting is enabled for this filetype
  end,
})
