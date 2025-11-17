alias nupdate = sudo nixos-rebuild --flake /home/kyle/.config/nix#kyle-nix switch;
alias nedit = nvim /home/kyle/.config/nix/nixos/configuration.nix;
alias hupdate = home-manager --flake /home/kyle/.config/nix#kyle@kyle-nix switch;
alias hedit = nvim /home/kyle/.config/nix/home-manager/home.nix;
alias nix-dir = cd /home/kyle/.config/nix;
alias nix-shell = nix-shell --run $env.SHELL;
alias nix-dev = nix develop -c $env.SHELL;
