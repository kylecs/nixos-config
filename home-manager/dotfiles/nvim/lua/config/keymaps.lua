-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim/kitty seamless split navigation. Replaces vim-kitty-navigator: we set
-- the IS_VIM user var ourselves, and use screen positions (not winnr) to
-- detect the vim edge so phantom side windows (e.g. snacks pickers) don't
-- swallow the jump back to kitty.
local function kitty_set_is_vim(value)
  vim.fn.system({ "kitten", "@", "set-user-vars", "IS_VIM=" .. value })
end

local function kitty_navigate(dir_vim, dir_kitty)
  local cur_win = vim.api.nvim_get_current_win()
  local cur_pos = vim.api.nvim_win_get_position(cur_win)

  vim.cmd("wincmd " .. dir_vim)

  local new_win = vim.api.nvim_get_current_win()
  local moved_correctly = false

  if cur_win ~= new_win then
    local new_pos = vim.api.nvim_win_get_position(new_win)
    local row_diff = new_pos[1] - cur_pos[1]
    local col_diff = new_pos[2] - cur_pos[2]

    if dir_vim == "h" then
      moved_correctly = col_diff < 0
    elseif dir_vim == "l" then
      moved_correctly = col_diff > 0
    elseif dir_vim == "k" then
      moved_correctly = row_diff < 0
    elseif dir_vim == "j" then
      moved_correctly = row_diff > 0
    end
  end

  if not moved_correctly then
    if cur_win ~= new_win then
      vim.api.nvim_set_current_win(cur_win)
    end
    vim.fn.system({ "kitten", "@", "focus-window", "--match", "neighbor:" .. dir_kitty })
  end
end

kitty_set_is_vim("true")
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function() kitty_set_is_vim("false") end,
})

vim.keymap.set("n", "<C-h>", function() kitty_navigate("h", "left") end, { desc = "Navigate Left (vim/kitty)" })
vim.keymap.set("n", "<C-j>", function() kitty_navigate("j", "bottom") end, { desc = "Navigate Down (vim/kitty)" })
vim.keymap.set("n", "<C-k>", function() kitty_navigate("k", "top") end, { desc = "Navigate Up (vim/kitty)" })
vim.keymap.set("n", "<C-l>", function() kitty_navigate("l", "right") end, { desc = "Navigate Right (vim/kitty)" })
