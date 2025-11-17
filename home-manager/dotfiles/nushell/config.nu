$env.config.edit_mode = 'vi'
$env.EDITOR = 'nvim'
$env.config.show_banner = false
$env.SHELL = 'nu'

source ./catppuccin_mocha.nu

# zoxide setup
source $"($nu.cache-dir)/zoxide.nu"

# nix specific config
source ./nix.nu

# starship setup
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# carapace setup
source $"($nu.cache-dir)/carapace.nu"

# Zoxide completion
def "nu-complete zoxide path" [context: string] {
    let parts = $context | split row " " | skip 1
    {
      options: {
        sort: false,
        completion_algorithm: substring,
        case_sensitive: false,
      },
      completions: (^zoxide query --list --exclude $env.PWD -- ...$parts | lines),
    }
  }

def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
  __zoxide_z ...$rest
}
