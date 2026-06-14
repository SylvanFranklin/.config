# Theme Change Notes

Current shared theme: Everforest dark medium.

Source: https://github.com/sainnhe/everforest

Everforest is a warm green-based colorscheme. This setup uses the upstream dark medium palette and adds transparency where each app can reasonably support it.

## Active Palette

These are the main colors currently mapped across Ghostty, Neovim, Sioyek, and Vesktop.

| Name | Hex | Sioyek RGB |
| --- | --- | --- |
| bg0 | `#232a2e` | `0.137 0.165 0.180` |
| bg1 | `#2d353b` | `0.176 0.208 0.231` |
| bg2 | `#343f44` | `0.204 0.247 0.267` |
| bg3 | `#3d484d` | `0.239 0.282 0.302` |
| bg4 | `#475258` | `0.278 0.322 0.345` |
| bg5 | `#4f585e` | `0.310 0.345 0.369` |
| bg_visual_red | `#543a48` | `0.329 0.227 0.282` |
| bg_visual_yellow | `#4d4c43` | `0.302 0.298 0.263` |
| bg_visual_green | `#425047` | `0.259 0.314 0.278` |
| bg_visual_blue | `#3a515d` | `0.227 0.318 0.365` |
| fg | `#d3c6aa` | `0.827 0.776 0.667` |
| red | `#e67e80` | `0.902 0.494 0.502` |
| orange | `#e69875` | `0.902 0.596 0.459` |
| yellow | `#dbbc7f` | `0.859 0.737 0.498` |
| green | `#a7c080` | `0.655 0.753 0.502` |
| aqua | `#83c092` | `0.514 0.753 0.573` |
| blue | `#7fbbb3` | `0.498 0.733 0.702` |
| purple | `#d699b6` | `0.839 0.600 0.714` |
| grey0 | `#7a8478` | `0.478 0.518 0.471` |
| grey1 | `#859289` | `0.522 0.573 0.537` |
| grey2 | `#9da9a0` | `0.616 0.663 0.627` |

Previous terminal/editor theme before this change was Gruvbox dark:

`#282828`, `#32302f`, `#ebdbb2`, `#504945`, `#cc241d`, `#98971a`, `#d79921`, `#458588`, `#b16286`, `#689d6a`, `#a89984`, `#928374`, `#fb4934`, `#b8bb26`, `#fabd2f`, `#83a598`, `#d3869b`, `#8ec07c`.

## Ghostty

File: `ghostty/config`

Ghostty is the terminal emulator. The theme is configured inline so it stays independent of Ghostty's bundled theme names.

Update these keys when changing themes:

- `background`
- `foreground`
- `cursor-color`
- `selection-background`
- `selection-foreground`
- `background-opacity`
- `palette = 0=...` through `palette = 15=...`

For transparency, tune `background-opacity`. Lower values are more transparent. Keep it high enough for terminal text contrast, usually `0.80` to `0.92`.

## Neovim

File: `nvim/init.lua`

Neovim is the editor. The colorscheme plugin is loaded through `vim.pack.add`.

For Everforest, these lines are the important ones:

```lua
{ src = "https://github.com/sainnhe/everforest" }
vim.o.background = "dark"
vim.g.everforest_background = "medium"
vim.g.everforest_transparent_background = 2
vim.g.everforest_better_performance = 1
vim.g.everforest_enable_italic = 1
vim.cmd.colorscheme(default_color)
```

To change themes in the future:

1. Replace the theme plugin in `vim.pack.add`.
2. Replace `local default_color = "everforest"` with the new colorscheme name.
3. Replace or remove theme-specific `vim.g.*` options.
4. Run Neovim once so `vim.pack` can fetch the new plugin.
5. Update `nvim/nvim-pack-lock.json` so the old theme plugin entry is replaced with the installed revision of the new one.

Transparency is currently controlled by `vim.g.everforest_transparent_background = 2`. Other themes usually have their own option, or require manually setting highlight backgrounds to `NONE`.

## Sioyek

File: `sioyek/prefs_user.config`

Sioyek is the PDF reader. It uses decimal RGB values from `0.000` to `1.000`, not hex.

Update these keys when changing themes:

- `background_color`
- `dark_mode_background_color`
- `custom_background_color`
- `custom_text_color`
- `status_bar_color`
- `status_bar_text_color`
- `page_separator_color`
- `text_highlight_color`
- `search_highlight_color`
- `link_highlight_color`
- `synctex_highlight_color`
- `visual_mark_color`
- `highlight_color_a` through `highlight_color_z`

To convert hex to Sioyek RGB, divide each hex channel by 255. Example: `#232a2e` is `35 42 46`, so the Sioyek value is `0.137 0.165 0.180`.

Sioyek does not expose the same kind of whole-window alpha transparency as Ghostty or CSS apps. The closest theme-level control is using dark custom colors and alpha-capable highlight settings like `visual_mark_color`.

## Vesktop / Vencord CSS

File: `vesktop/themes/minimal.styles.css`

Vesktop is the Discord client, and Vencord CSS is the custom stylesheet injected into Discord. Discord class names change often, so the CSS intentionally combines stable CSS variables with broad fallback selectors.

Update the `:root` block first:

- `--everforest-*` variables are the local palette.
- Discord variables like `--background-primary`, `--text-normal`, `--brand-500`, and `--status-*` map the palette into Discord.

Transparency is handled with `rgba(...)` background variables and broad selectors that set major Discord layout containers to `transparent`. If Discord updates and opaque panels come back, inspect the new class and add one narrowly scoped selector near the existing transparency block.

## Recommended Theme Change Workflow

1. Pick a single source palette and decide on dark/light plus contrast variant.
2. Update Ghostty first so terminal colors are stable.
3. Update Neovim plugin/options and verify `:colorscheme` loads.
4. Convert hex colors to Sioyek RGB floats and update PDF/UI colors.
5. Update Vesktop CSS variables, then patch any newly opaque Discord surfaces.
6. Keep this file's Active Palette table in sync with the new theme.
