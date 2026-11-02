// Herdr 98's drawing kit: Windows 98 colors, bevels, buttons, title bars,
// menus' bits and sounds, shared by every role of the win98 mod.
//
// Pixels: Win98 is drawn in whole device pixels. `unit()` gives u(n): n Win98
// pixels in layout px, so a 1 px bevel stays one crisp pixel at any zoom
// (scale 2 doubles every pixel, "Large Fonts").

import { div, svg, image, PathBuilder, Background } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { settings, shared, setShared, playSound, run, layout, openOverlay, closeOverlay, exec, window as appWindow } from "herdr";

export const C = {
  face: "#c0c0c0",
  light: "#dfdfdf",
  hi: "#ffffff",
  shadow: "#808080",
  dark: "#0a0a0a",
  text: "#000000",
  gray: "#808080",
  white: "#ffffff",
  navy: "#000080",
  blue: "#1084d0",
  title: "#ffffff",
  inactive: "#808080",
  inactive2: "#b5b5b5",
  inactiveText: "#c0c0c0",
  desktop: "#008080",
  tip: "#ffffe1",
  select: "#000080",
  selectText: "#ffffff",
  disabled: "#808080",
};

export const FONT = "Pixelated MS Sans Serif";
export const DOS = "PxPlus IBM VGA 8x16";
export const ASSETS = "mods/win98";

// ---- pixels

export function scale() {
  const k = shared("win98.scale");
  return k === 2 ? 2 : 1;
}

export function unit() {
  const z = Number(settings()?.zoom) || 1;
  const k = scale() / z;
  const u = (n) => n * k;
  u.k = k;
  return u;
}

// ---- text

/** A label in the Win98 font. `&File` underlines the F (its access key). */
export function label(text, o = {}) {
  const s = String(text ?? "");
  const amp = o.noAccess ? -1 : s.indexOf("&");
  let el;
  if (amp >= 0 && amp < s.length - 1) {
    el = h_flex().flex_none();
    if (amp > 0) el = el.child(div().child(s.slice(0, amp)));
    el = el.child(div().underline().child(s[amp + 1]));
    if (amp + 2 < s.length) el = el.child(div().child(s.slice(amp + 2)));
  } else {
    el = div().child(s);
  }
  if (o.bold) el = el.font_weight(700);
  if (o.color) el = el.text_color(o.color);
  return el;
}

export function plain(text) {
  return String(text ?? "").replace(/&(.)/, "$1");
}

/** The root of every role: Win98 font, size and text color. */
export function root(u, el) {
  return el.font_family(FONT).text_size(u(11)).line_height(`${u(13)}px`).text_color(C.text);
}

// ---- bevels

// Layers from outside in: [right+bottom color, top+left color].
const BEVEL = {
  raised: [[C.dark, C.hi], [C.shadow, C.light]],
  pressed: [[C.hi, C.dark], [C.light, C.shadow]],
  window: [[C.dark, C.light], [C.shadow, C.hi]],
  field: [[C.hi, C.shadow], [C.light, C.dark]],
  well: [[C.hi, C.shadow]],
  bump: [[C.shadow, C.hi]],
  dent: [[C.hi, C.shadow]],
  thin: [[C.shadow, C.hi]],
  flat: [],
};

/**
 * Wraps `content` in a Win98 bevel. o: { id, press: kind shown while held
 * (needs id), bg, pad: n | [y, x] }. Chain size and flex on the result.
 */
export function bevel(u, kind, content, o = {}) {
  const layers = BEVEL[kind] ?? [];
  const held = o.press ? BEVEL[o.press] : null;
  const pad = Array.isArray(o.pad) ? o.pad : [o.pad ?? 0, o.pad ?? 0];
  let inner = div()
    .flex()
    .flex_col()
    .flex_1()
    .min_w(0)
    .min_h(0)
    .pt(u(pad[0]))
    .pb(u(pad[0]))
    .pl(u(pad[1]))
    .pr(u(pad[1]));
  if (o.bg) inner = inner.bg(o.bg);
  if (o.center) inner = inner.items_center().justify_center();
  if (o.id && held && o.shift !== false)
    inner = inner.id(`${o.id}~c`).active((s) => s.pt(u(pad[0] + 1)).pb(u(Math.max(0, pad[0] - 1))).pl(u(pad[1] + 1)).pr(u(Math.max(0, pad[1] - 1))));
  inner = inner.child(content);
  let el = inner;
  const press = Boolean(o.id && held);
  for (let i = layers.length - 1; i >= 0; i--) {
    const [rb, tl] = layers[i];
    const [hrb, htl] = press ? (held[i] ?? held[held.length - 1]) : [rb, tl];
    let a = (press ? div().id(`${o.id}~t${i}`) : div()).flex().flex_col().flex_1().min_w(0).min_h(0).border_t(u(1)).border_l(u(1)).border_color(tl);
    let b = (press ? div().id(`${o.id}~b${i}`) : div()).flex().flex_col().min_w(0).min_h(0).border_r(u(1)).border_b(u(1)).border_color(rb);
    if (press) {
      a = a.active((s) => s.border_color(htl));
      b = b.active((s) => s.border_color(hrb));
    }
    b = b.child(a.child(el));
    if (i > 0) b = b.flex_1();
    el = b;
  }
  if (!layers.length) el = div().flex().flex_col().child(inner);
  return el;
}

/** A press of a control in a window_drag bar, or a float, is the control's. */
export function own(el) {
  return el.on_mouse_down("left", (_e, cx) => cx.stop_propagation());
}

/**
 * A push button. o: { w, h, default (the thick outline), toggled (stays in),
 * disabled, bold, pad: [y, x], onDown(e, cx) }.
 */
export function button(u, id, content, onClick, o = {}) {
  const kind = o.toggled ? "pressed" : "raised";
  const text = typeof content === "string" ? label(content, { bold: o.bold, color: o.disabled ? C.disabled : undefined }) : content;
  const face = h_flex().flex_1().items_center().justify_center().gap(u(4)).child(text);
  let b = bevel(u, kind, face, {
    id: o.disabled ? undefined : id,
    press: o.disabled || o.toggled ? undefined : "pressed",
    pad: o.pad ?? [0, 4],
    bg: o.bg ?? C.face,
  });
  if (o.default) b = div().flex().flex_col().border(u(1)).border_color(C.dark).child(b.flex_1());
  b = b.id(`${id}~btn`);
  if (o.w) b = b.w(u(o.w));
  if (o.minW) b = b.min_w(u(o.minW));
  if (o.h) b = b.h(u(o.h));
  if (o.tooltip) b = b.tooltip(o.tooltip);
  b = b.on_mouse_down("left", (e, cx) => {
    cx.stop_propagation();
    o.onDown?.(e, cx);
  });
  if (o.onRight) b = b.on_mouse_down("right", (e, cx) => {
    cx.stop_propagation();
    o.onRight(e, cx);
  });
  if (!o.disabled && onClick) b = b.on_click((e, cx) => onClick(e, cx));
  return b;
}

/** An etched line: vertical (in bars) or horizontal (menus, dialogs). */
export function etch(u, vertical = false) {
  return vertical
    ? h_flex().flex_none().h_full().child(div().w(u(1)).h_full().bg(C.shadow)).child(div().w(u(1)).h_full().bg(C.hi))
    : v_flex().flex_none().w_full().child(div().h(u(1)).w_full().bg(C.shadow)).child(div().h(u(1)).w_full().bg(C.hi));
}

/** The raised grip at the start of a toolbar band. */
export function grip(u) {
  return bevel(u, "bump", div().w(u(1)).h_full()).h(u(20)).flex_none();
}

// ---- gradients

const RECT = () => PathBuilder.fill().move_to("0%", "0%").line_to("100%", "0%").line_to("100%", "100%").line_to("0%", "100%").close().build();

/** A layer that fills its parent (relative) with a left-to-right gradient. */
export function gradient(from, to, angle = 90) {
  return window.paint_path(RECT(), Background.linear_gradient(angle, from, to)).absolute().top(0).left(0).size_full();
}

/** A layer that fills its parent with a 1 px dither (Win98's checked buttons). */
export function dither(u, color = C.hi) {
  return window.paint_path(RECT(), Background.checkerboard(color, Math.max(1, u(1) * (Number(settings()?.zoom) || 1)))).absolute().top(0).left(0).size_full();
}

// ---- icons

/** A pixel-art icon: 32 px art (name.svg) for big sizes, 16 px (name-sm.svg), 9 px badges (name-xs.svg). */
export function icon(u, name, size = 16) {
  const file = size >= 24 ? name : size >= 12 ? `${name}-sm` : `${name}-xs`;
  return image(`${ASSETS}/icons/${file}.svg`).flex_none().w(u(size)).h(u(size));
}

/** A program's icon (the app's table), small: shells are MS-DOS. */
export function programIcon(u, program, size = 16) {
  if (!program || program.shell || program.key === "shell" || !program.icon) return icon(u, "dos", size);
  if (program.tint) {
    return div()
      .flex_none()
      .w(u(size))
      .h(u(size))
      .bg(program.tile ?? C.navy)
      .flex()
      .items_center()
      .justify_center()
      .child(svg(program.icon).w(u(size - 4)).h(u(size - 4)).text_color(program.color ?? C.white));
  }
  return image(program.icon).flex_none().w(u(size)).h(u(size));
}

// ---- title bars

const GLYPH = { min: "ctl-min", max: "ctl-max", restore: "ctl-restore", close: "ctl-close", help: "ctl-help" };

/** One of a title bar's little buttons: min, max, restore, close, help. */
export function control(u, id, kind, onClick, tooltip) {
  return button(u, id, svg(`${ASSETS}/icons/${GLYPH[kind]}.svg`).w(u(8)).h(u(7)).text_color(C.text), onClick, {
    w: 16,
    h: 14,
    pad: [0, 0],
    tooltip,
  }).flex_none();
}

/**
 * A window's title bar. o: { id, title, icon (element), active, controls:
 * [[kind, onClick, tooltip]], onDouble, onRight, drag (true: presses go to
 * the window/float under it) }.
 */
export function titleBar(u, o) {
  const active = o.active !== false;
  const controls = o.controls ?? [];
  const row = h_flex().flex_none().gap(0).items_center();
  controls.forEach(([kind, fn, tip], i) => {
    // Close stands 2 px apart from the others.
    const gap = kind === "close" && i > 0 ? u(2) : 0;
    row.child(div().pl(gap).child(control(u, `${o.id}-${kind}`, kind, fn, tip)));
  });
  let bar = h_flex()
    .id(`${o.id}-title`)
    .relative()
    .flex_none()
    .w_full()
    .map((el) => (o.fill ? el.flex_1() : el.h(u(o.height ?? 18))))
    .items_center()
    .pl(u(3))
    .pr(u(2))
    .gap(u(3))
    .child(active ? gradient(C.navy, C.blue) : gradient(C.inactive, C.inactive2))
    .when(Boolean(o.icon), (el) => el.child(div().relative().flex_none().child(o.icon)))
    .child(
      div()
        .relative()
        .flex_1()
        .min_w(0)
        .truncate()
        .font_weight(700)
        .text_color(active ? C.title : C.inactiveText)
        .child(o.title ?? ""),
    )
    .child(div().relative().child(row));
  if (o.onDouble || o.onClick)
    bar = bar.on_click((e, cx) => {
      if (e.click_count >= 2) o.onDouble?.(e, cx);
      else o.onClick?.(e, cx);
    });
  if (o.onRight)
    bar = bar.on_mouse_down("right", (e, cx) => {
      cx.stop_propagation();
      o.onRight(e, cx);
    });
  return bar;
}

/**
 * A whole Win98 window: frame, title bar, optional menu bar, body.
 * o: { id, title, icon, active, controls, menu (element), body, status (element), w, h }
 */
export function win(u, o) {
  const col = v_flex()
    .flex_1()
    .min_h(0)
    .gap(u(1))
    .child(titleBar(u, o))
    .when(Boolean(o.menu), (el) => el.child(o.menu))
    .child(div().flex().flex_col().flex_1().min_h(0).child(o.body))
    .when(Boolean(o.status), (el) => el.child(o.status));
  let w = bevel(u, "window", col, { pad: 1, bg: C.face });
  if (o.w) w = w.w(u(o.w));
  if (o.h) w = w.h(u(o.h));
  return w;
}

/** A sunken white field (text boxes, lists). */
export function field(u, content, o = {}) {
  return bevel(u, "field", content, { pad: o.pad ?? [2, 3], bg: o.bg ?? C.white });
}

/** A status bar panel. */
export function well(u, content, o = {}) {
  return bevel(u, "well", content, { pad: o.pad ?? [1, 3], bg: o.bg });
}

// ---- menus

// Menu metrics in Win98 px; the menu role draws exactly these.
export const MENU = { row: 18, startRow: 34, sep: 9, frame: 3, banner: 21 };

/** A menu's size in Win98 px. */
export function menuSize(items, start = false) {
  let rows = 0;
  let seps = 0;
  let longest = 0;
  let keys = 0;
  for (const it of items) {
    if (it.sep) {
      seps++;
      continue;
    }
    rows++;
    longest = Math.max(longest, plain(it.label).length);
    keys = Math.max(keys, (it.shortcut ?? "").length);
  }
  const row = start ? MENU.startRow : MENU.row;
  const w = start ? Math.max(180, MENU.banner + 48 + longest * 6 + 24) : Math.max(120, 28 + longest * 6 + (keys ? keys * 6 + 24 : 0) + 20);
  const h = rows * row + seps * MENU.sep + MENU.frame * 2;
  return { w, h };
}

function zoom() {
  return Number(settings()?.zoom) || 1;
}

/**
 * Opens a Win98 popup menu (the menu role). items: [{ label: "&New", icon,
 * shortcut, act: { run: [command, args], dialog, app, ... }, sub: [items],
 * disabled, checked, radio, bold, sep: true }]. at: window px, or
 * { above: bounds } (the Start menu, over its button). Returns its overlay id.
 */
export function openMenu(items, at, o = {}) {
  const k = scale();
  const { w, h } = menuSize(items, o.start);
  const width = o.width ?? w;
  let where = at;
  if (at?.above) where = { x: at.above.x, y: Math.max(0, at.above.y - h * k) };
  return openOverlay({
    mod: "win98",
    kind: "popup",
    frame: "none",
    width: (width * k) / zoom(),
    height: (h * k) / zoom(),
    ...(where ? { at: where } : {}),
    props: { role: "menu", items, parents: o.parents ?? [], start: Boolean(o.start), owner: o.owner ?? null },
  });
}

const DIALOG_W = { prompt: 340, confirm: 330, run: 350, shutdown: 330, about: 380, taskman: 360, display: 400, mycomputer: 420, bin: 380, message: 330, network: 380, welcome: 560, logoff: 300, datetime: 330 };

/** Opens a Win98 dialog (the dialog role) as a window you can drag by its title: kind and its props. */
export function openDialog(kind, p = {}) {
  const k = scale();
  const w = p.width ?? DIALOG_W[kind] ?? 340;
  return openOverlay({
    mod: "win98",
    kind: "window",
    frame: "none",
    width: (w * k) / zoom(),
    props: { role: "dialog", kind, ...p },
  });
}

/** Does what a menu item or icon says: { run, dialog, app, shared, url, sound }. */
export function perform(act) {
  if (!act) return;
  if (act.sound) sfx(act.sound);
  if (act.run) run(act.run[0], act.run[1] ?? {});
  if (act.dialog) openDialog(act.dialog.kind, act.dialog);
  if (act.app) setApp(act.app, "open");
  if (act.shared) setShared(act.shared[0], act.shared[1]);
  if (act.url) {
    const mac = appWindow()?.platform === "macos";
    exec(mac ? "open" : "xdg-open", [act.url]).catch(() => {});
  }
}

export { closeOverlay };

// ---- sounds

/** Plays a Herdr 98 sound unless sounds are off (settings, or the speaker in the tray). */
export function sfx(name) {
  if (settings()?.sounds?.enabled === false) return;
  if (shared("win98.mute") === true) return;
  try {
    playSound(`${ASSETS}/sounds/${name}.mp3`);
  } catch {}
}

// ---- state shared by the roles

/** Which game windows are open: { mines: "open" | "min", sol: ... }. */
export function apps() {
  return shared("win98.apps") ?? {};
}

export function setApp(name, state) {
  const a = { ...apps() };
  if (state) a[name] = state;
  else delete a[name];
  setShared("win98.apps", a);
}

// ---- paths, DOS style

export function dosPath(path, home) {
  if (!path) return "C:\\";
  let p = path;
  if (home && (p === home || p.startsWith(home + "/"))) p = "C:\\My Documents" + p.slice(home.length);
  else p = "C:" + p;
  return p.replaceAll("/", "\\").replace(/\\$/, "") || "C:\\";
}

// ---- the layout's pixel sizes, kept whole at any zoom

const FIT = { taskbar: 28, desktop: 84 };

/** Sizes the layout's bars in Win98 pixels for this zoom and scale; true if it changed. */
export function fitLayout() {
  const l = layout();
  if (!l || typeof l !== "object") return false;
  const z = Number(settings()?.zoom) || 1;
  const k = scale() / z;
  const want = (n) => Math.round(n * k * 1000) / 1000;
  let changed = false;
  // Large Fonts: the MS-DOS font at a crisp 32 px too; Small: Herdr's zoom as usual.
  const font = scale() === 2 ? want(16) : 16;
  if (Math.abs((l.font_size ?? 0) - font) > 0.01) {
    l.font_size = font;
    changed = true;
  }
  const visit = (n) => {
    if (!n || typeof n !== "object") return;
    if (FIT[n.id] && Math.abs((n.size?.px ?? 0) - want(FIT[n.id])) > 0.01) {
      n.size = { px: want(FIT[n.id]) };
      run("layout.resize", { id: n.id, px: n.size.px });
      changed = true;
    }
    const pane = n.content?.pane;
    if (pane?.header && Math.abs((pane.header.height ?? 0) - want(18)) > 0.01) {
      pane.header.height = want(18);
      changed = true;
    }
    if (pane && Math.abs((pane.border?.width ?? 0) - want(3)) > 0.01) {
      pane.border = { width: want(3), color: C.face };
      pane.focus = { width: want(3), color: C.face };
      changed = true;
    }
    for (const c of n.children ?? []) visit(c);
  };
  visit(l);
  if (changed) run("layout.set", { layout: l });
  return changed;
}
