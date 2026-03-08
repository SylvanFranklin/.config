# clippy.yazi
Clippy integration for Yazi file manager.

Special thanks to https://github.com/orhnk/system-clipboard.yazi for the reference implementation.

# Requirements

- Install Yazi (https://github.com/sxyazi/yazi)
- Install Clippy (https://github.com/neilberkman/clippy)

# Installation

Add the package via: 

`ya pkg add Gallardo994/clippy`

Add `plugin clippy` to the `keymap.toml`, for example:

```
[[mgr.prepend_keymap]]
on = [ "f", "c" ]
run = [ "plugin clippy" ]
desc = "Copy with Clippy"
```

If you'd like to automatically copy yanked files to the clipboard, you can do something like this:

```
[[mgr.prepend_keymap]]
on = [ "y" ]
run = [ "yank", "plugin clippy" ]
```