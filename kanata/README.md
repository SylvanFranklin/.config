# Colemak-DH migration

`kanata.kbd` mirrors the selected Karabiner profile's ANSI letter mapping,
Caps Lock tap for Escape / hold for left Control, and left Control + `[` for
Escape. Kanata's tap-hold decision is not identical to Karabiner's: pressing
another key resolves the hold immediately, and a tap held past 200 ms becomes
Control. Check this behavior in use.

The device allowlist contains the built-in keyboard and the currently detected
unnamed device (identified by the hash reported by `kanata --list`). This is
intentionally conservative: other keyboards, including the two devices ignored
by Karabiner, are not grabbed. Device hashes can change. Inspect `kanata --list`
before adding a device; never include a virtual keyboard. A US ANSI macOS input
source is assumed. Unmapped keys pass through.

## Before switching

1. Run `kanata --check --cfg ~/.config/kanata/kanata.kbd` and confirm the device
   allowlist with `kanata --list`.
2. Confirm the Karabiner VirtualHIDDevice driver and its daemon are active.
   Kanata needs these even when Karabiner-Elements remapping is stopped. Grant
   Kanata the macOS Input Monitoring and Accessibility permissions it needs.
3. Arrange a timed, independent rollback and a way to use the mouse or another
   unaffected keyboard. Stop Karabiner-Elements remapping and prevent its login
   startup before starting Kanata; do not stop the VirtualHIDDevice daemon.
4. Start Kanata in a temporary foreground session with an automatic stop, and
   verify plain and shifted letters, Command shortcuts, Caps tap and hold,
   Control-[, and both physical keyboards. Confirm Karabiner remapping is not
   running. If anything fails, stop Kanata first and reopen Karabiner-Elements.
5. Only after the trial works, arrange persistent startup that cannot overlap
   Karabiner-Elements, and verify behavior after login and reboot.

No startup service is installed by this repository yet. Validation with
`--check` only checks configuration parsing; it does not test permissions,
device access, virtual output, or actual key behavior. Kanata documents the
emergency exit as left Control + Space + Escape, but do not rely on it as the
only recovery method.
