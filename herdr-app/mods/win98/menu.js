// A Win98 popup menu: props { items, parents, start }. Hover opens
// submenus to the right; a choice closes the whole chain and acts.
// The Start menu (start: true) has big rows and the Herdr98 banner.

import { div, svg, image } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { props, closeOverlay, setShared, shared } from "herdr";
import { C, ASSETS, MENU, unit, root, bevel, label, icon, perform, openMenu, etch, scale, gradient } from "./kit.js";

function openMenus() {
  return shared("win98.menus") ?? [];
}

/** Closes a submenu and every submenu opened from it. */
function closeTree(id) {
  const all = openMenus();
  const doomed = all.filter((m) => m.id === id || m.parents.includes(id)).map((m) => m.id);
  if (!doomed.includes(id)) doomed.push(id);
  for (const d of doomed.reverse()) closeOverlay(d);
  setShared("win98.menus", all.filter((m) => !doomed.includes(m.id)));
}

export default class Menu {
  init(_p, cx) {
    this.at = -1;
    this.sub = null; // { id, index }
    this.focus = cx.focus_handle();
    this.focus.focus();
    // A menu bar keeps its label pressed while its menu is open.
    this.owner = props()?.owner ?? null;
    if (this.owner) setShared("win98.menu.owner", this.owner);
    // Every open submenu and its parents, so closing one closes what hangs off it.
    const p = props() ?? {};
    // A top menu starts the list over (menus closed by a click outside leave stale ids).
    setShared("win98.menus", (p.parents ?? []).length ? [...openMenus(), { id: p.overlay, parents: p.parents }] : []);
    // Escape is the app's (it closes the overlay before our key handler
    // sees it): a binding of our own, deeper in, comes first.
    try {
      cx.bind_keys([{ keystroke: "escape", action: "win98_menu_escape", context: "Win98Menu" }]);
    } catch {}
  }

  escape() {
    if (this.sub) closeTree(this.sub.id);
    this.sub = null;
    closeOverlay(props().overlay);
    if (shared("win98.start") && !(props().parents ?? []).length) setShared("win98.start", null);
    this.release();
  }

  release() {
    if (this.owner && shared("win98.menu.owner") === this.owner) setShared("win98.menu.owner", null);
  }

  items() {
    return props()?.items ?? [];
  }

  closeAll() {
    const p = props() ?? {};
    if (this.sub) closeTree(this.sub.id);
    closeOverlay(p.overlay);
    for (const id of [...(p.parents ?? [])].reverse()) closeOverlay(id);
    if (shared("win98.start")) setShared("win98.start", null);
    this.release();
  }

  choose(it) {
    if (!it || it.disabled || it.sep) return;
    if (it.sub) return;
    this.closeAll();
    perform(it.act);
  }

  openSub(i, bounds) {
    const it = this.items()[i];
    if (this.sub && this.sub.index === i) return;
    if (this.sub) {
      closeTree(this.sub.id);
      this.sub = null;
    }
    if (!it?.sub || it.disabled) return;
    const k = scale();
    const p = props() ?? {};
    const at = bounds ? { x: bounds.x + bounds.width + 2 * k, y: bounds.y - MENU.frame * k } : undefined;
    const id = openMenu(it.sub, at, { parents: [...(p.parents ?? []), p.overlay] });
    this.sub = { id, index: i };
  }

  move(d) {
    const items = this.items();
    if (!items.length) return;
    let i = this.at;
    for (let n = 0; n < items.length; n++) {
      i = (i + d + items.length) % items.length;
      if (!items[i].sep) break;
    }
    this.at = i;
  }

  key(e, cx) {
    const items = this.items();
    switch (e.key) {
      case "down":
        this.move(1);
        break;
      case "up":
        this.move(-1);
        break;
      case "right":
        if (items[this.at]?.sub) this.openSub(this.at, null);
        break;
      case "left":
      case "escape":
        this.escape();
        break;
      case "enter":
      case "space":
        if (items[this.at]?.sub) this.openSub(this.at, null);
        else this.choose(items[this.at]);
        break;
      default: {
        // An access key picks its item.
        const ch = (e.key_char ?? e.key ?? "").toLowerCase();
        const i = items.findIndex((it) => !it.sep && (it.label ?? "").toLowerCase().includes("&" + ch));
        if (i < 0) return;
        this.at = i;
        if (items[i].sub) this.openSub(i, null);
        else this.choose(items[i]);
      }
    }
    cx.stop_propagation();
    cx.notify();
  }

  row(u, it, i, start) {
    if (it.sep) return div().h(u(MENU.sep)).flex().items_center().px(u(start ? 2 : 1)).child(etch(u));
    const on = i === this.at && !it.disabled;
    const h = start ? MENU.startRow : MENU.row;
    const fg = it.disabled ? C.disabled : on ? C.selectText : C.text;
    const lead = start
      ? div().w(u(40)).flex_none().flex().items_center().justify_center().child(it.icon ? icon(u, it.icon, 32) : it.img ? image(it.img).w(u(32)).h(u(32)) : div())
      : div()
          .w(u(22))
          .flex_none()
          .flex()
          .items_center()
          .justify_center()
          .when(Boolean(it.checked), (el) => el.child(svg(`${ASSETS}/icons/check.svg`).w(u(7)).h(u(7)).text_color(fg)))
          .when(Boolean(it.radio), (el) => el.child(div().w(u(6)).h(u(6)).rounded(u(3)).bg(fg)))
          .when(Boolean(it.icon) && !it.checked && !it.radio, (el) => el.child(icon(u, it.icon, 16)))
          .when(Boolean(it.img) && !it.icon, (el) => el.child(image(it.img).w(u(16)).h(u(16))));
    return h_flex()
      .id(`mi-${i}`)
      .h(u(h))
      .w_full()
      .items_center()
      .text_color(fg)
      .when(on, (el) => el.bg(C.select))
      .on_mouse_move((e, cx) => {
        if (this.at === i && (this.sub?.index === i || !it.sub)) return;
        this.at = i;
        this.openSub(i, e.bounds);
        cx.notify();
      })
      .on_click((_e, cx) => {
        if (it.sub) {
          this.openSub(i, null);
          cx.notify();
        } else this.choose(it);
      })
      .child(lead)
      .child(div().flex_1().min_w(0).child(label(it.label, { bold: it.bold })))
      .when(Boolean(it.shortcut), (el) => el.child(div().flex_none().pl(u(16)).child(it.shortcut)))
      .child(
        div()
          .w(u(start ? 16 : 18))
          .flex_none()
          .flex()
          .items_center()
          .justify_center()
          .when(Boolean(it.sub), (el) => el.child(svg(`${ASSETS}/icons/arrow-right.svg`).w(u(4)).h(u(7)).text_color(fg))),
      );
  }

  render(_cx) {
    const u = unit();
    const p = props() ?? {};
    const items = this.items();
    const start = Boolean(p.start);
    const list = v_flex().flex_1().min_w(0).children(items.map((it, i) => this.row(u, it, i, start)));
    const body = start
      ? h_flex()
          .size_full()
          .child(
            div()
              .relative()
              .w(u(MENU.banner))
              .h_full()
              .flex_none()
              .flex()
              .flex_col()
              .justify_end()
              .bg(C.navy)
              .child(gradient("#000000", C.navy, 180))
              .child(image(`${ASSETS}/img/banner${scale() === 2 ? "@2x" : ""}.png`).w(u(MENU.banner)).h(u(110)).flex_none()),
          )
          .child(list)
      : list;
    return root(
      u,
      v_flex()
        .id("menu")
        .key_context("Win98Menu")
        .on_action("win98_menu_escape", () => this.escape())
        .track_focus(this.focus)
        .on_key_down((e, cx) => this.key(e, cx))
        .on_mouse_down_out((_e, _cx) => {
          if (start && shared("win98.start")) setShared("win98.start", null);
          this.release();
        })
        .size_full(),
    ).child(bevel(u, "window", body, { pad: 1, bg: C.face }).size_full());
  }
}
