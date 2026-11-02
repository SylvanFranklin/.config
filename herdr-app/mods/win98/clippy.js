// The Office Assistant, floating over the desktop. When an agent needs you
// (blocked) or finished while you looked away (done), it pops a balloon that
// takes you there. Click it for a tip. Display Properties (or its balloon)
// hides it; Start > Programs > Accessories brings it back.

import { div, image } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { agents, run, shared, setShared, placement } from "herdr";
import { C, ASSETS, unit, root, button, label, sfx, own } from "./kit.js";

const TIPS = [
  "It looks like you're herding agents.\n\nDid you know? Ctrl+Esc opens the Start menu.",
  "Click a tab's taskbar button while it's\nshown to minimize it (Herdr settles it).\nClick again to bring it back.",
  "Ctrl+Shift+Esc opens Close Program:\nevery terminal Herdr runs, and End Task.",
  "Right-click a folder on the desktop to\nrename or close that space.",
  "Waiting on an agent? Mines is on\nthe desktop. I won't tell anyone.",
  "Double-click a window's title bar to\nmaximize it. Double-click again to restore.",
  "Start > Run... opens any command line\nin a new window, like it's 1998.",
  "Shut Down > Restart in DOS mode\ntakes you to the Terminals layout.",
  "Log Off takes you back to Herdr's\nnormal layout. I'll miss you.",
];

export default class Clippy {
  init() {
    this.dismissed = new Set();
    this.tip = null;
  }

  news() {
    const list = agents()
      .filter((a) => (a.status === "blocked" || a.status === "done") && !a.focused)
      .filter((a) => !this.dismissed.has(`${a.address}:${a.status}`))
      .sort((a, b) => (a.status === "blocked") - (b.status === "blocked") || a.seq - b.seq);
    return list.pop() ?? null;
  }

  render(_cx) {
    if (shared("win98.clippy") === "off") return div();
    const u = unit();
    const a = this.news();
    const right = placement()?.edge !== "left";
    let balloon = null;
    if (a) {
      const name = a.program?.name ?? a.app ?? "Your agent";
      const where = `'${a.space_name} \\ ${a.tab_name}'`;
      const text =
        a.status === "blocked"
          ? `It looks like ${name} in\n${where} is waiting for you.\n\nWould you like help?`
          : `It looks like ${name} finished\nin ${where}.\n\nWant to see what it did?`;
      balloon = this.balloon(u, text, [
        ["Take me there", () => {
          run("agent.focus", { terminal: a.address });
          this.dismissed.add(`${a.address}:${a.status}`);
        }],
        ["Not now", () => this.dismissed.add(`${a.address}:${a.status}`)],
      ]);
    } else if (this.tip !== null) {
      balloon = this.balloon(u, TIPS[this.tip % TIPS.length], [
        ["Next tip", () => (this.tip = (this.tip + 1) % TIPS.length)],
        ["Close", () => (this.tip = null)],
        ["Hide me", () => setShared("win98.clippy", "off")],
      ]);
    }
    // Clean the dismissed list once their agents moved on.
    for (const k of [...this.dismissed]) {
      const [addr, st] = k.split(":");
      if (!agents().some((x) => x.address === addr && x.status === st)) this.dismissed.delete(k);
    }
    const clip = own(
      div()
        .id("clippy")
        .relative()
        .flex_none()
        .cursor_pointer()
        .when(Boolean(a), (el) => el.loop("top", { from: 0, to: u(-5), period: 800 }))
        .on_click((_e, cx) => {
          this.tip = this.tip === null ? Math.floor(Math.random() * TIPS.length) : null;
          sfx("clippy");
          cx.notify();
        })
        .child(image(`${ASSETS}/img/clippy.svg`).w(u(64)).h(u(80))),
    );
    return root(
      u,
      v_flex()
        .p(u(4))
        .gap(u(2))
        .map((el) => (right ? el.items_end() : el.items_start())),
    )
      .when(Boolean(balloon), (el) => el.child(balloon))
      .child(clip);
  }

  balloon(u, text, actions) {
    return v_flex()
      .w(u(200))
      .p(u(8))
      .gap(u(8))
      .bg(C.tip)
      .border(u(1))
      .border_color(C.text)
      .rounded(u(8))
      .child(
        v_flex().children(
          String(text)
            .split("\n")
            .map((l) => div().child(l || " ")),
        ),
      )
      .child(
        v_flex()
          .gap(u(3))
          .children(
            actions.map(([t, fn], i) =>
              own(
                h_flex()
                  .id(`clip-${i}`)
                  .gap(u(5))
                  .items_center()
                  .cursor_pointer()
                  .on_click((_e, cx) => {
                    fn();
                    cx.notify();
                  })
                  .child(div().w(u(7)).h(u(7)).rounded(u(4)).bg(C.navy))
                  .child(div().text_color(C.navy).underline().child(t)),
              ),
            ),
          ),
      );
  }
}
