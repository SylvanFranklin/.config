// Herdr 98: the whole Windows 98 layout is this one mod, in roles.
// The layout and overlays give each copy props { role }:
//   taskbar  the Start button, tabs as windows, the tray and clock
//   desktop  icons on the teal desktop: spaces as folders, games, bin
//   window   a pane's title bar (the layout's pane header)
//   menu     a popup menu (the Start menu too)
//   dialog   message boxes, prompts, Run, Shut Down, About, Close Program
//   mines    Mines (a floating window)
//   sol      Solitaire (a floating window)
//   clippy   the Office Assistant (a floating window)

import { View, div } from "gpui-kit";
import { props } from "herdr";
import Taskbar from "./taskbar.js";
import Desktop from "./desktop.js";
import PaneWindow from "./window.js";
import Menu from "./menu.js";
import Dialog from "./dialog.js";
import Mines from "./mines.js";
import Sol from "./sol.js";
import Clippy from "./clippy.js";

const ROLES = { taskbar: Taskbar, desktop: Desktop, window: PaneWindow, menu: Menu, dialog: Dialog, mines: Mines, sol: Sol, clippy: Clippy };

export default class Win98 extends View {
  init(p, cx) {
    const pr = props() ?? p ?? {};
    const R = ROLES[pr.role];
    this.role = R ? new R() : null;
    this.role?.init?.(pr, cx);
  }

  render(cx) {
    if (!this.role) return div().child(`win98: no role "${props()?.role}"`);
    return this.role.render(cx);
  }
}
