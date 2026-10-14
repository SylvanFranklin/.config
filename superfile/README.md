# Superfile

Installed with `brew install superfile`. Start with `spf` or `spf ~/Documents/projects`.

The macOS files in `~/Library/Application Support/superfile/` are symlinked to
the config and hotkeys in this directory. Original defaults are saved there as
`config.toml.default-backup` and `hotkeys.toml.default-backup`.

Uses Everforest dark medium, terminal transparency, Neovim for files and
directories, built-in previews, and zoxide. Nerd Font icons are disabled to
match Ghostty's Geist Mono font. Updates are managed through Homebrew.

## Keys

- `h/j/k/l`: parent directory, down, up, enter/open
- `Enter`: open
- `/`: search; `.`: toggle hidden files
- `e`: edit file in Neovim; `E`: edit directory in Neovim
- `v`: selection mode; `y/x/p`: copy/cut/paste; `d`: delete
- `a/r`: create/rename
- `n`: new panel; `Tab` / `Shift-Tab`: switch panels; `q`: close panel
- `f`: toggle preview; `z`: zoxide
- `?`: help; `Ctrl-C`: quit

Official source: https://github.com/yorukot/superfile
Documentation: https://superfile.dev/
