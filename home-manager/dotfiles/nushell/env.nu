# setup cache dir for later use
mkdir $"($nu.cache-dir)"

# zoxide
zoxide init nushell | save --force $"($nu.cache-dir)/zoxide.nu"

# carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"

