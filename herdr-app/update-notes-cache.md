# Herdr changelog

## [0.1.15] - 2026-11-10

### New
- **Terminal rows are as tall as in Ghostty.** Herdr used to add about 15% extra space to every line, so the same font looked looser than in other terminals. Rows are now sized from the font itself, at every zoom and font size, and more lines fit on screen. (#66)
- **A layout can choose the mod that shows notifications:** `"toast": "<mod>"` in the layout. The shipped toast is unchanged. (#364, thanks @ngotchac)
- Mods can scroll a normal scroll area to one of its children: `ScrollHandle.new()`, `.track_scroll(handle)` and `handle.scroll_to_item(index)`.
- Mods: `knownAgents()` now rejects when the check itself fails, instead of reporting every agent as not installed.

### Fixed
- **On macOS, files and screenshots can be dragged into a terminal.** Dropping a file from Finder works right after typing, and the floating screenshot thumbnail (Cmd+Shift+4) attaches to Claude Code and other programs. (#654, #709, thanks @EliaTogni and @rqres)
- **On macOS, the + menu no longer shows every agent as "not installed" right after login or a restart,** and `herdr-app check` works then too. When Herdr can't check, it says so instead of calling agents missing.
- **On macOS, reopen older terminals once.** Terminals opened before herdr-core 0.1.20 can still end when Herdr quits, and this update quits Herdr once. Once herdr-core is 0.1.20 or newer (Settings > Updates shows it), close and reopen those terminals, or restart your Mac, and they are safe from then on.
- **On Linux, Herdr opens on a fresh Ubuntu 26.04 or Fedora 45.** It no longer needs the X11 keyboard library on Wayland. (#839)
- **A terminal printing a lot of output no longer freezes the whole window.** (#748)
- **An agent you come back to leaves "done"** in the agents list.
- With many tabs, the tab bar scrolls to the active tab. (#802)
- Coming back to a terminal that another device (your phone) resized takes its size back when you click it or switch to its tab or space, not only when you type.
- The Spaces sidebar groups worktrees right away in large repositories (seconds before).
- The Open worktree dialog takes the keyboard after a slow first load. (#798, thanks @ilstar)
- Creating a worktree on this machine while a terminal on another machine is focused no longer fails and leaves the space out of the sidebar.
- Playing a GIF or other animated image in a terminal uses far less memory, and gives it back when the image leaves the screen. (#560)
- Settings: the font list stays inside the window, and Add machine shows login instructions you can copy.
- Layout terminal blocks stay in place when the connection to their terminal drops. (#761)
- Dragging a block that is squeezed very small no longer crashes Herdr.
- On Windows, clicking into an ssh or tmux terminal no longer sends a stray drag that changes its selection. (#759)
- Ctrl and Alt held during a mouse click or scroll, and Shift during a scroll, reach programs that track the mouse. Shift+click still selects text.
- The picker's earlier rows can be reached with the keyboard.
- The wide CJK space (U+3000) is drawn when the font has a glyph for it. (#777)
- A sub-agent on another machine shows under its parent in the agents list.
- A bottom pane header draws its divider above the header. (#712, thanks @Zihao-Qi)
- An agent's spinner after a title prefix no longer shows in its name. (#626, thanks @namastex888)
- An agent title that is a folder no longer replaces the tab's name. (#740, thanks @chasereyn)
- Clicking the "Esc" hint in a dialog closes it. (#690, thanks @VinhLe1410)
- Mod icons load when the mod folder is a link. (#427, thanks @ngotchac)
- The Changes diff keeps tab indentation. (#366, thanks @sundarshahi)
- From this version on, Herdr keeps space and tab details that a newer Herdr saved on the same machine, and saved files keep their permissions. (#729, #722, thanks @abhijit-s)
- On Windows, updates apply when Herdr was started from its install folder, file links with encoded characters open, and Add machine lists every host from a wildcard `Include`. (#673, #663, #672, thanks @sundarshahi)
- On KDE Plasma, the Herdr icon shows right after install. (#703, thanks @okurmustafa)


## [0.1.14] - 2026-11-08

### New
- Settings > Add machine tells you what to run when a machine needs a password, a new host key or herdr-core installed there, instead of opening a setup terminal. Once you've added it yourself, the list shows it as added.
- Mods can swap two panes by id with `pane.swap`. (#665, thanks @sQVe)
- Kimi Code gets its own icon. (#647, thanks @SuTang-vain)
- Mods can give `exec` a timeout: `exec(cmd, args, { timeout })` in milliseconds, up to 10 minutes (30 seconds by default). Opening a worktree in a large repository uses it.

### Fixed
- **Mods no longer all break at once after a while.** Opening Settings, the palette or a picker, or switching layouts, slowly filled up the mods' memory until every mod showed "This view could not be re-rendered". Mods also open faster now. For mod authors: the top of a mod's file now runs once and is shared by all its copies; keep per-copy state in the class.
- **On macOS, `herdr-app check` no longer leaves a second Herdr icon in the Dock.** Quitting that icon, or switching Herdr off under Background App Activity in Settings, ended every terminal. (#398, thanks @revofusion)
- Cmd+W and Cmd+Shift+W with Settings, the palette or a picker open close that window, not the terminal behind it.
- A pane that opens while the window is still laying out shows all of its output: a long line could lose its end, on screen and when copied.
- Layouts you've edited by hand keep all their pieces when a terminal in them ends or can't be reached.
- Two agents in one tab show their own names in the agents list.
- Codex started from the + menu keeps its own session, so closing one Codex no longer ends the others. This needs Codex 0.156 or newer. (#657, thanks @martintrifunov)
- On Windows, the + menu no longer marks installed agents as not installed.
- When Herdr can't reach a running core, it says why and how to fix it, instead of showing the install screen.
- On Linux with fcitx4, Chinese and other input methods keep working. (#558, thanks @SailorMoonQ)
- On Linux, the input method keeps working after switching windows.
- On KDE, the window no longer opens tiny. (#601, thanks @zdziejowski)
- New terminals start in the right folder when you open several at once, and start in your home folder when the folder they'd inherit is gone. (#511, thanks @JJLiebig)
- Zooming into a pane while moving between agents shows the right pane. (#568, thanks @martintrifunov)
- A kept sub-agent shows once in the agents list, under its parent. (#539, thanks @mertkaradayi)
- Toasts name agents by their proper name. (#530, thanks @thuanlm215)
- Find highlights all of a wide character. (#587, thanks @chanyang721)
- Clicking in a program that takes the mouse clears your selection. (#369, thanks @sundarshahi)
- The Changes list fills its panel and scrolls to every changed file. (#474, thanks @shadownrx)
- The palette scrolls past group titles, and shows ⌘ only on macOS. (#531, thanks @patrick-xin; #478, thanks @JJLiebig)
- Dialogs, the confirm dialog and Settings look right: sized to their content, rounded corners, layout previews and long theme names stay in their cards. (#593, thanks @karlAlnebratt; #570, #437, #621, thanks @martintrifunov; #457, thanks @yankewei)
- The sidebar rail's items line up. (#453, thanks @log4b)
- Pressing rename again closes the rename prompt. (#569, thanks @martintrifunov)
- Idle windows no longer wake every mod 20 times a second. (#548, thanks @abhijit-s)
- `herdr-app check` no longer touches the running app's shared mod state. (#516, thanks @JJLiebig)
- The terminal menu leaves out pane items where there's no pane, and mods see which terminal has the keyboard. (#553, #554, thanks @thuanlm215)

## [0.1.13] - 2026-11-04
<!-- spotlight macos -->

### New
- **On macOS, programs in your terminals can reach your local network and use the microphone.** Herdr's core is now its own app, Herdr Core: macOS asks once for each (the network prompt may say herdr-core), click Allow. Terminals opened before this update need to be reopened once. Node, Copilot or a model server on another machine connect; voice input works. (herdr-core#100)
- **Find in a terminal.** Cmd+F on macOS, Ctrl+Shift+F on Linux and Windows searches the screen and its history. If you've edited your keys.json, add "cmd-f": "terminal.search" (or "ctrl-shift-f") to its terminal section yourself. (#436, thanks @SOUMITRO-SAHA)
- Terminal panes show a scroll thumb you can drag. (#428, thanks @msly)
- Programming ligatures, off by default: set font_ligatures to true in settings. (#244, thanks @ruilopesm)
- Mods and agents can scroll a terminal's history with terminal.scroll, and keys.json can bind a command with arguments. (#455, thanks @sQVe)
- dsh-tui agents have their own icon and start from the new agent menu. (#335, thanks @tsonglew)

### Fixed
- Programs start at the size of their pane, so the first screen of an agent isn't drawn at the wrong width.
- On Windows, Nerd Font icons show again.
- On Windows, links with an = in them open in the browser.
- On Windows, agents and the Files panel work on remote Windows machines.
- On Windows without a GPU, Herdr uses far less CPU. (#424, thanks @kiote)
- On Windows, OneDrive folders and paths with curly quotes open in Files. (#354, thanks @chanyang721)
- Ctrl+[, Ctrl+I, Ctrl+M, Ctrl+_ and Ctrl+- reach programs as they do in other terminals.
- Cmd+C reaches the program when nothing is selected. (#319, thanks @sllrs)
- The agents list no longer breaks with "This view could not be re-rendered" on busy setups. (#485, thanks @mike-north)
- Open worktree no longer breaks in repos with many worktrees. (#486, thanks @martin-ro)
- Switching back to the tab from a home page gives the terminal the keyboard again. (#484, thanks @ngotchac)
- Cmd+1 to 9 follow the order of spaces in the sidebar.
- The pane focus ring shows only where the keyboard really is.
- Shortcut keys work right after start, even with no space open.
- The shortcuts overlay closes with the same key, and Ctrl+? opens it on Linux.
- Wide fallback symbols like 🕹 fit their cell instead of covering the next one. (#468)
- Braille dots are spaced evenly. (#351, thanks @leoscricca)
- On Linux, no light flash when Herdr starts on a dark desktop. (#225, thanks @claytonfaria)
- On Wayland with several seats, the mouse and keyboard work. (#123)
- Tabs you're not looking at resize with the window. (#340, thanks @imakil195)
- Mods see when the window loses and gets focus. (#350, thanks @ngotchac)
- The font picker no longer crashes on some fonts. (#316, thanks @ruilopesm)
- The command palette scrolls smoothly. (#348, thanks @patrick-xin)
- Add machine lists hosts from Include files in ~/.ssh/config. (#328, thanks @ashrodan)
- Selected text in mod text views stays readable.

## [0.1.12] - 2026-11-02
<!-- spotlight macos -->

### New
- **On macOS, your agents now run fully apart from the app.** Close Herdr, quit it, update it: your agents keep running. Agents already running pick this up the next time they start.
- On macOS, the system may ask once if **herdr-core** can access a folder like Documents. That's Herdr; click Allow.
- On macOS, Settings > Keyboard chooses what Option does: Alt, typing characters like á and €, or left or right Option as Alt.
- A machine that was rebuilt or replaced shows "rebuilt · Connect" in the sidebar: one click connects to the new one.
- Seen and pinned agents are shared between Herdr windows and the phone app.
- Mods can take the keyboard, so moving focus can land on them. (#283, thanks @Osc100)
- PiG agents have their own icon. (#299, thanks @balcsida)
- Add machine takes a port, like `can@server:2222`.

### Fixed
- On Linux, color emoji show in color instead of blank (Fedora's emoji font).
- Emoji like ✍️ and ❤️ take two cells and draw in color. (#287, thanks @occultsound)
- On macOS, programs in Herdr terminals can ask for the microphone, camera and to control other apps. (#137, thanks @shivanandasai-altir; #252)
- Agents on another machine find the commands their shell setup puts on PATH. (#262, thanks @tajchert)
- New spaces open on the machine you're looking at.
- Horizontal scrolling reaches programs like vim and less.
- Clicks work in Textual apps.
- btop's braille graphs draw without gaps.
- Nerd Font icons use your terminal font.
- Rounded corners and dashed lines in boxes draw like Ghostty. (#255, thanks @occultsound)
- Herdr uses less CPU with many busy agents.
- A big project no longer makes the folder watcher burn a CPU core. (#263, #257)
- Mod pictures and icons update when their file is saved.
- Moving focus back into a split returns to the pane you came from. (#304, thanks @sundarshahi)
- Unnamed tabs show what their agent is doing in the agents list. (#281, thanks @sundarshahi)
- A new tab with no space open starts a space. (#303, thanks @sundarshahi)
- Files marks the files inside a new folder, and opens folder symlinks. (#309, thanks @Nagell; #301, thanks @azaeldrm)
- Lists in mods follow the zoom. (#296, thanks @Calonca)
- The + menu shows your agents right away. (#251, thanks @shellscape)
- Grok shows its own icon. (#293, thanks @Zynoo71)
- A malformed command can't close the tab you're on. (#297, thanks @chanyang721)
- On Linux, Ctrl+Insert and Shift+Insert copy and paste in new installs; add them to your keys.json to get them on an existing one. (#258, thanks @dr-moreira)
- In full screen on macOS, the sidebar header lines up. (#261, thanks @runkids)
- On Windows, file names in Korean, Chinese and other languages show and open in Files. (#236, thanks @loonslo)
- On Windows, Esc then Ctrl+C reach the program as two keys. (#162, thanks @JJLiebig)
- In Git Bash on Windows, the installer points to the PowerShell one. (#238, thanks @sundarshahi)

## [0.1.11] - 2026-10-31

### Fixed
- The window no longer freezes or spikes the CPU for seconds at a time while mods run.
- Programs get the new colors right away when you change the theme or switch light and dark. (#122, thanks @geoqiao)
- On macOS, Vietnamese input methods like OpenKey, DauKey and Gõ Nhanh type in terminals. (#230, thanks @emizuki)
- Links a program breaks across lines open with Cmd+click. (thanks @pdeveltere)
- Editing the theme you're using repaints the window. (thanks @shawnyeager)
- Mod tooltips show in embedded windows. (thanks @ruilopesm)
- Opening the palette or a popup again closes it instead of stacking another. (#151, thanks @ruttybob)
- The status bar shows your real palette key. (#150, thanks @ruttybob)
- The Go-to popup keeps the selected row in view. (#152, thanks @ruttybob)
- No empty strip under the agents list in a wide sidebar. (thanks @kaofelix)
- A failed update check no longer says "Up to date". (#186, thanks @weichieh0204)

## [0.1.10] - 2026-10-30

### Fixed
- Images that Claude Code, yazi and other programs draw with kitty placeholders show up instead of rows of boxes. (#110)
- Images are the right size and sharp on Retina and other HiDPI screens. (#70, thanks @wpdmitry)
- Hover effects work in Claude Code and other programs that track the mouse.
- A drag that starts in another pane no longer reaches nvim or tmux, and a drag inside one keeps working when you let go outside it.
- Dragging a selection past the top or bottom of a terminal scrolls it.
- Closing a tab or space no longer brings its terminals back as unnamed tabs for a moment. (#108)
- The + menu starts agents with 1 to 9 while it's open, and shows your own shortcuts. (#102, #133, thanks @notHuman9504)
- Add a machine lists every host in your SSH config and shows the install prompt on top. (#95)
- Your own alert sounds play, and sound changes apply without a restart.
- A layout block that shows the focused agent stays in your layout when that agent ends.
- The Files panel keeps your open folders and preview when you switch spaces. (#86, thanks @ruilopesm)
- Dragging a space in the sidebar shows where it will land. (#114, thanks @takahashi-seiryu)
- Long agent titles cut off before the pin and the time. (#127, thanks @rashim2104)
- The + above Spaces lines up with the sidebar button. (#121, thanks @weskor)
- On macOS, a slow mouse wheel scrolls terminals. (#80, thanks @juanibiapina)
- On macOS, Cmd+V pastes copied files and screenshots into agents. (#105, thanks @WesleyBLDC)
- On macOS, Cmd+Shift+[ and ] switch tabs, and other Shift+punctuation shortcuts work.
- On macOS, Option types [ ] { } on ABC-QWERTZ and ABC-AZERTY.
- On macOS, Vietnamese Telex and other input methods compose. (#93)
- On macOS, keys typed with Fn held, like Fn+Esc for a backtick, reach terminals.
- On macOS, agents started from the + menu load your login setup, like Homebrew's PATH.
- On Windows, Ctrl+V pastes text, like Windows Terminal.
- On Windows, the Files panel opens folders with spaces or parentheses in their path. (#130)
- On Windows, the window buttons line up and stay crisp at every display scale.
- On Linux, Chinese typed through fcitx or ibus on X11 comes out right. (#97)
- On Linux, accent keys no longer type a stray character first. (#87, thanks @ruilopesm)
- On Linux, right-clicking a tab no longer opens the window manager's menu too. (#79, thanks @dev-gvs)
- `terminal.open` with a command starts in the folder you give it.
- `herdr-app check` no longer crashes on mods with scrolling lists or layout animations.

## [0.1.9] - 2026-10-30

### Fixed
- On macOS, updates keep Herdr's Apple signature again, so macOS stops forgetting the permissions you gave Herdr.
- Herdr no longer uses CPU in the background when the Changes or Files panel is open in a git repo.
- Mods use less CPU while they wait for work.

## [0.1.8] - 2026-10-30

### New
- **Option works as Alt on macOS.** Claude Code's Option shortcuts work, automatically on US keyboards. Change it with `option_as_alt` in settings.json.
- **Programs can copy to your clipboard,** also from other machines. Pi's or Claude Code's own mouse selection lands on your clipboard.
- **Your own commands in the + menu.** Entries in programs.json show up, shell functions included.

### Fixed
- Accent keys work on macOS and with ibus on Linux, and Caps Lock types capitals on macOS.
- @, [ and friends type on Slovenian, German and other Mac layouts in every program.
- Terminal colors show exactly as programs set them, so powerline prompts look right.
- Double-click selects a word, triple-click a line.
- Agents start from the + menu under fish, and one that fails at launch says why.
- On macOS, the window buttons stay clear of a narrow sidebar and the tabs.
- You can type a commit message in the Changes panel.
- Spaces named with emoji or accents work everywhere.
- The font list in Settings scrolls on its own.
- A downloaded update installs at the next start, even after a crash.

## [0.1.7] - 2026-10-29

### Fixed
- Herdr no longer freezes when a terminal shows an older Nerd Font icon it has no picture for, like some powerlevel10k battery icons. It draws them as text instead.

## [0.1.6] - 2026-10-29

### New
- **Coming from herdr?** The welcome says what carries over and gives you one line for your agent to bring your keybinds and settings across. Open it again with Show the welcome again in the command palette.
- **Updates at a glance.** Settings → Updates shows the app and the core on one row each, with What's new a click away.
- **herdr-core updates with Herdr.** After Herdr updates, its core moves to the latest version too. Your terminals keep running.
- **Screenshots in feedback.** Drop images straight onto the feedback form.

### Fixed
- Paste and copy in a peek go to the terminal you're peeking at, not the agent behind it.
- Scroll back through thousands of lines instead of a few hundred.
- Mod data, like topics and colors, can't get lost if Herdr closes in the middle of saving.
- Commands with an argument they don't know say so instead of acting on the current terminal.
- On Windows, file links at the end of a sentence open the right file.

## [0.1.5] - 2026-10-27
<!-- spotlight -->

### New
- **Drag panes where you want them.** Hover the top of a pane and grab the dots. Drop it on another pane to swap them, or near an edge to put it beside. A highlight shows where it lands.
  ![Dragging a pane beside another](https://media.herdr.dev/0.1.5/pane-drag.webp)
- **Ctrl-click a terminal to peek at it.** When an agent mentions another terminal, like t2, Ctrl-click (Cmd on macOS) its address to see it over your tab. Go to jumps there.
  ![Peeking at a terminal an agent mentioned](https://media.herdr.dev/0.1.5/peek.webp)
- **Agents can see the window.** `herdr-app shot` saves a picture of Herdr as it looks right now, so an agent building a mod can check its work. `herdr-app --skill` and `hc --skill` teach an agent the rest.
- **What changed, after every update.** Release notes like these, in Settings → Updates, including versions you skipped.

### Fixed
- nvim and other full-screen programs redraw right after you resize their pane.
- On Windows, AltGr and accent keys type the right characters, and Shift+Enter adds a new line in Claude Code.
- On Windows, new terminals start in PowerShell 7 when you have it, and Herdr follows their folder.
- On macOS, Herdr keeps the permissions you gave it across updates.
- Short menus open next to the pointer instead of near the top of the window.
- Removing a worktree asks once, then removes it.
- Mods can fetch from the web, know their size, and clean up when they close.

## [0.1.4] - 2026-10-23
<!-- spotlight -->

### New
- **See the agents that need you first.** Pick Priority beside the Agents title: agents waiting on you, then the ones that just finished, then the ones still working. Grouped by space is still there.
- **Pin the ones you're watching.** Hover an agent and click the pin. Pinned agents stay on top in both views until they end.
- **Fold what you don't need.** Click a space or section header to fold it; the header still shows how many agents are inside.

### Fixed
- Temporary agent sandboxes stay out of your spaces and machine lists.
- The agents list keeps its place when you scroll.
- An agent you're in moves to its new section right away.
- A pane closes when its terminal finishes instead of showing “has finished”.
- On macOS, the red close button hides Herdr instead of leaving it without a window.
- Mods reload cleanly when you save them, and tell you when a save didn't load.
