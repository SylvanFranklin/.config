// The desktop's icons, down the left edge of the teal: My Computer, the
// Recycle Bin, every space as a folder (the shown one selected, its agents'
// state as a badge), the games, Network Neighborhood. One click opens (Win98's
// "single-click to open" web style); right-click for each icon's menu, or the
// desktop's.

import { div } from "gpui-kit";
import { v_flex } from "gpui-base";
import { spaces, run } from "herdr";
import { C, unit, root, icon, openMenu, openDialog, perform, sfx } from "./kit.js";
import { closeSpaceAsk } from "./taskbar.js";

export default class Desktop {
  init() {
    this.sel = null;
  }

  item(u, key, ico, text, o = {}) {
    const on = o.selected ?? this.sel === key;
    const badge = o.badge;
    return v_flex()
      .id(`dk-${key}`)
      .flex_none()
      .w(u(76))
      .pt(u(4))
      .pb(u(6))
      .items_center()
      .gap(u(3))
      .on_mouse_down("left", (_e, cx) => {
        cx.stop_propagation();
        this.sel = key;
        cx.notify();
      })
      .on_click((_e, cx) => {
        o.open?.();
        cx.notify();
      })
      .on_mouse_down("right", (_e, cx) => {
        cx.stop_propagation();
        this.sel = key;
        if (o.menu) openMenu(o.menu());
        cx.notify();
      })
      .child(
        div()
          .relative()
          .child(icon(u, ico, 32))
          .when(on, (el) => el.child(div().absolute().top(0).left(0).size_full().bg("#00008060")))
          .when(Boolean(badge), (el) =>
            el.child(
              div()
                .absolute()
                .left(u(-2))
                .bottom(u(-2))
                .child(icon(u, badge, 16))
                .when(badge === "warn-badge", (b) => b.loop("opacity", { from: 0, to: 1, period: 900 })),
            ),
          ),
      )
      .child(
        div()
          .max_w(u(74))
          .px(u(1))
          .text_center()
          .text_color(C.white)
          .border(u(1))
          .border_color(on ? "#ffff00" : "#00000000")
          .when(on, (el) => el.bg(C.navy))
          .child(text),
      );
  }

  render(_cx) {
    const u = unit();
    const all = spaces();
    const badgeOf = (s) => (s.status === "blocked" ? "warn-badge" : s.status === "working" ? "hourglass" : s.status === "done" ? "check-badge" : null);
    const items = [
      this.item(u, "computer", "computer", "My Computer", { open: () => openDialog("mycomputer", {}) }),
      this.item(u, "bin", "bin", "Recycle Bin", { open: () => openDialog("bin", {}) }),
      ...all.map((s) =>
        this.item(u, s.id, s.machine ? "netfolder" : s.active ? "folder-open" : "folder", s.name, {
          selected: s.active,
          badge: badgeOf(s),
          open: () => run("space.select", { id: s.id }),
          menu: () => [
            { label: "&Open", bold: true, act: { run: ["space.select", { id: s.id }] } },
            { label: "New &Tab...", act: { dialog: { kind: "prompt", title: "New Tab", text: `Type a name for the new tab in '${s.name}':`, icon: "dos", command: { name: "tab.new", args: { space: s.id } } } } },
            { sep: true },
            { label: "Re&name", act: { dialog: { kind: "prompt", title: "Rename", text: "Type a new name for this space:", icon: "folder", value: s.name, command: { name: "space.rename", args: { id: s.id } } } } },
            { label: "&Delete", act: { dialog: { kind: "confirm", ...closeSpaceAsk(s) } } },
            { sep: true },
            {
              label: "P&roperties",
              act: {
                dialog: {
                  kind: "message",
                  title: `${s.name} Properties`,
                  icon: "folder",
                  text: `Type:  Space\nLocation:  ${s.machine ?? "This computer"}\nFolder:  ${s.folder || "~"}\nBranch:  ${s.branch ?? "(none)"}\nContains:  ${s.tabs.length} tab(s)\nStatus:  ${s.status ?? "idle"}`,
                },
              },
            },
          ],
        }),
      ),
      this.item(u, "mines", "mines", "Mines", { open: () => perform({ app: "mines" }) }),
      this.item(u, "sol", "sol", "Solitaire", { open: () => perform({ app: "sol" }) }),
      this.item(u, "net", "network", "Network Neighborhood", { open: () => openDialog("network", {}) }),
    ];
    return root(
      u,
      v_flex()
        .id("desktop")
        .size_full()
        .pt(u(6))
        .items_center()
        .overflow_y_scroll()
        .on_mouse_down("left", (_e, cx) => {
          this.sel = null;
          cx.notify();
        })
        .on_mouse_down("right", () => {
          sfx("menu");
          openMenu([
            { label: "Arrange &Icons", sub: [{ label: "by &Name", disabled: true }, { label: "by &Type", disabled: true }, { label: "&Auto Arrange", checked: true, disabled: true }] },
            { label: "Line &up Icons", disabled: true },
            { sep: true },
            { label: "&Refresh", act: { run: ["layout.switch", { name: "win98" }] } },
            { sep: true },
            { label: "&Paste", disabled: true },
            { label: "Paste &Shortcut", disabled: true },
            { sep: true },
            {
              label: "Ne&w",
              sub: [
                { label: "&Space...", icon: "folder", act: { dialog: { kind: "prompt", title: "New Space", text: "Type a name for the new space:", icon: "folder", machines: true, command: { name: "space.new", args: {} } } } },
                { label: "&Tab...", icon: "dos", act: { dialog: { kind: "prompt", title: "New Tab", text: "Type a name for the new tab:", icon: "dos", command: { name: "tab.new", args: {} } } } },
              ],
            },
            { sep: true },
            { label: "P&roperties", act: { dialog: { kind: "display" } } },
          ]);
        }),
    ).children(items);
  }
}
