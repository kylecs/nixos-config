-- wezterm.conf
local wezterm = require 'wezterm'


local config = {}


-- VISUAL
config.color_scheme = "Catppuccin Mocha"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- FONT
config.font_size = 16.0
config.font = wezterm.font("Fira Mono Nerd Font")

-- KEYS
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000, }

config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- {
  --   key = 'h',
  --   mods = 'CTRL',
  --   action = wezterm.action.ActivatePaneDirection('Left'),
  -- },
  -- {
  --   key = 'j',
  --   mods = 'CTRL',
  --   action = wezterm.action.ActivatePaneDirection('Down'),
  -- },
  -- {
  --   key = 'k',
  --   mods = 'CTRL',
  --   action = wezterm.action.ActivatePaneDirection('Up'),
  -- },
  -- {
  --   key = 'l',
  --   mods = 'CTRL',
  --   action = wezterm.action.ActivatePaneDirection('Right'),
  -- },
  {
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'DefaultDomain',
  },
  { key = '1', mods = 'LEADER', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = wezterm.action.ActivateTab(8) },
  { key = '0', mods = 'LEADER', action = wezterm.action.ActivateTab(9) },
  { key = ',', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },
  { key = '.', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
}

local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local function is_vim_fallback(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = process_info and process_info.name

  return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

for key, direction in pairs(direction_keys) do
  table.insert(config.keys, {
    key = key,
    mods = 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- If in vim, pass the keystroke through
        win:perform_action({ SendKey = { key = key, mods = 'CTRL' } }, pane)
      else
        -- Otherwise, activate the adjacent pane in the given direction
        win:perform_action({ ActivatePaneDirection = direction }, pane)
      end
    end),
  })
end


return config
