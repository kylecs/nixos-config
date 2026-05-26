# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Apply Changes

```bash
# Apply NixOS system configuration (requires sudo)
sudo nixos-rebuild --flake /home/kyle/.config/nix#kyle-nix switch

# Apply home-manager configuration (user-level, no sudo)
home-manager --flake /home/kyle/.config/nix#kyle@kyle-nix switch
```

Shell aliases `nupdate` and `hupdate` are shorthand for these commands.

## Architecture

This is a NixOS flake-based configuration with two outputs:

- **`nixosConfigurations.kyle-nix`** — system-level config rooted at `nixos/configuration.nix`
- **`homeConfigurations.kyle@kyle-nix`** — user-level config rooted at `home-manager/home.nix`

The flake tracks two nixpkgs channels: stable (`nixos-25.11`) and unstable. The unstable channel is exposed as `pkgs-unstable` via `extraSpecialArgs` and used selectively for packages that need newer versions (e.g., kitty in `terminal.nix`).

### Home Manager modules

`home-manager/home.nix` imports five modules, each owning a concern:

| File | Responsibility |
|---|---|
| `terminal.nix` | tmux, neovim, zsh (oh-my-zsh), kitty, ghostty, starship, carapace |
| `swe.nix` | emacs (doom), vscode, LSPs, language servers, dev tools |
| `niri.nix` | window manager and compositor config symlinks |
| `entertainment.nix` | steam, spotify, vlc, prismlauncher, vesktop |
| `video.nix` | obs-studio, davinci-resolve, ffmpeg |

### Dotfiles strategy

Config files live under `home-manager/dotfiles/` and reach `~/.config/` in one of two ways:

- **`home.file`** — Nix-managed copy into the store (used for ghostty, nushell)
- **`home.activation`** — `ln -snf` symlink pointing back into the repo (used for nvim, kitty, niri, waybar, hypr, fuzzel, wlogout, doom emacs)

Symlinked configs can be edited in-place in the repo without re-running `hupdate`. Copied configs require `hupdate` to pick up changes.

### Neovim

The active neovim config is `home-manager/dotfiles/nvim/` (LazyVim starter), symlinked to `~/.config/nvim`. The `dotfiles/nvim-custom/` directory is an unused alternate config.
