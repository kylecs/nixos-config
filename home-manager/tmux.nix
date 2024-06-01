{ ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = " 
      unbind C-b
# remap prefix from 'C-b' to 'C-a'
      set-option -g prefix C-a
      bind-key C-a send-prefix

# split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '\"'
      unbind %

      set-option -ga terminal-overrides \"alacritty:Tc\"

# Enable mouse control (clickable windows, panes, resizable panes)
      set -g mouse on

# fix vim mode change delay
      set -sg escape-time 10

# don't rename windows automatically
      set-option -g allow-rename off

# pane switch vim keybindings
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

# DESIGN TWEAKS

# don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

# clock mode
      setw -g clock-mode-colour colour1

# copy mode
      setw -g mode-style 'fg=colour1 bg=colour18 bold'

# pane borders
#       set -g pane-border-status bottom
#       set -g pane-border-style 'fg=colour1'
#       set -g pane-active-border-style 'fg=colour3'

#       set -g pane-border-format '#{pane_index} #{pane_current_command}'

# statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'fg=colour1'
      set -g status-left ''
      set -g status-right '%Y-%m-%d %H:%M '
      set -g status-right-length 50
      set -g status-left-length 10
# messages
      set -g message-style 'fg=colour2 bg=colour0 bold'
      ";
  };
}
