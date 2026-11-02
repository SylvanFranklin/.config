import { div, image } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { shared, setShared } from "herdr";
import { unit, root, C, bevel, button, win, icon, label, own, apps, setApp, openMenu, openDialog, sfx, ASSETS } from "./kit.js";

const LEVELS = { beginner: [9, 9, 10], intermediate: [16, 16, 40], expert: [30, 16, 99] };
const COLORS = [C.face, "#0000ff", "#008000", "#ff0000", "#000080", "#800000", "#008080", "#000000", "#808080"];
const SEGMENTS = ["abcdef", "bc", "abdeg", "abcdg", "bcfg", "acdfg", "acdefg", "abc", "abcdefg", "abcdfg"];
const SEG_RECTS = [[2, 1, 7, 2], [9, 3, 2, 7], [9, 12, 2, 7], [2, 19, 7, 2], [0, 12, 2, 7], [0, 3, 2, 7], [2, 10, 7, 2]];

function art(u, name, size = 16) {
  return image(`${ASSETS}/icons/mines-${name}.svg`).w(u(size)).h(u(size)).flex_none();
}

function counter(u, value) {
  const chars = value < 0 ? `-${String(Math.min(99, -value)).padStart(2, "0")}` : String(Math.min(999, value)).padStart(3, "0");
  return bevel(u, "well", h_flex().gap(u(2)).children([...chars].map((ch) => {
    const lit = ch === "-" ? "g" : SEGMENTS[Number(ch)];
    return div().relative().w(u(11)).h(u(23)).children(SEG_RECTS.map(([x, y, w, h], i) =>
      div().absolute().left(u(x)).top(u(y)).w(u(w)).h(u(h)).bg(lit.includes("abcdefg"[i]) ? "#ff0000" : "#650000")));
  })), { bg: "#000000", pad: [0, 1] }).flex_none();
}

export default class Mines {
  init() {
    this.options = { level: "beginner", marks: true, color: true, sound: true, best: {}, ...(shared("win98.mines") ?? {}) };
    if (!LEVELS[this.options.level]) this.options.level = "beginner";
    this.req = shared("win98.mines.req")?.t;
    this.reset();
  }

  save() { setShared("win98.mines", this.options); }
  stop() { this.timer?.cancel(); this.timer = null; }
  reset() {
    this.stop();
    [this.cols, this.rows, this.total] = LEVELS[this.options.level];
    this.cells = Array.from({ length: this.cols * this.rows }, () => ({ mine: false, n: 0, open: false, mark: 0 }));
    this.state = "ready";
    this.seconds = 0;
    this.held = -1;
    this.boom = -1;
  }

  neighbors(i) {
    const result = [], x = i % this.cols, y = Math.floor(i / this.cols);
    for (let dy = -1; dy <= 1; dy++) for (let dx = -1; dx <= 1; dx++) {
      if ((dx || dy) && x + dx >= 0 && x + dx < this.cols && y + dy >= 0 && y + dy < this.rows)
        result.push((y + dy) * this.cols + x + dx);
    }
    return result;
  }

  start(i, cx) {
    const excluded = new Set([i, ...this.neighbors(i)]);
    const pool = this.cells.map((_c, j) => j).filter((j) => !excluded.has(j));
    for (let n = 0; n < this.total; n++) {
      const j = n + Math.floor(Math.random() * (pool.length - n));
      [pool[n], pool[j]] = [pool[j], pool[n]];
      this.cells[pool[n]].mine = true;
    }
    this.cells.forEach((c, j) => { c.n = this.neighbors(j).filter((k) => this.cells[k].mine).length; });
    this.state = "playing";
    this.started = Date.now();
    this.timer = cx.timer.every(1000, (cx) => {
      this.seconds = Math.min(999, Math.floor((Date.now() - this.started) / 1000));
      if (this.seconds === 999) this.stop();
      cx.notify();
    });
  }

  reveal(i, cx) {
    const c = this.cells[i];
    if (!c || c.open || c.mark === 1 || this.state === "lost" || this.state === "won") return;
    if (this.state === "ready") this.start(i, cx);
    if (c.mine) {
      this.boom = i;
      this.state = "lost";
      this.held = -1;
      this.stop();
      if (this.options.sound) sfx("mines-boom");
      return;
    }
    const todo = [i];
    while (todo.length) {
      const j = todo.pop(), cell = this.cells[j];
      if (cell.open || cell.mark === 1 || cell.mine) continue;
      cell.open = true;
      cell.mark = 0;
      if (cell.n === 0) todo.push(...this.neighbors(j));
    }
    if (this.cells.every((cell) => cell.mine || cell.open)) {
      this.state = "won";
      this.held = -1;
      this.seconds = Math.min(999, Math.floor((Date.now() - this.started) / 1000));
      this.stop();
      this.cells.forEach((cell) => { if (cell.mine) cell.mark = 1; });
      const best = this.options.best[this.options.level];
      if (best === undefined || this.seconds < best) {
        this.options.best = { ...this.options.best, [this.options.level]: this.seconds };
        this.save();
      }
      if (this.options.sound) sfx("tada");
    }
  }

  chord(i, cx) {
    const c = this.cells[i];
    if (!c.open || !c.n || this.state !== "playing") return;
    const near = this.neighbors(i);
    if (near.filter((j) => this.cells[j].mark === 1).length === c.n)
      for (const j of near) this.reveal(j, cx);
  }

  request(cmd) {
    if (LEVELS[cmd]) { this.options.level = cmd; this.save(); this.reset(); }
    else if (cmd === "new") this.reset();
    else if (["marks", "sound", "color"].includes(cmd)) {
      this.options[cmd] = !this.options[cmd];
      if (cmd === "marks" && !this.options.marks) this.cells.forEach((c) => { if (c.mark === 2) c.mark = 0; });
      this.save();
    } else if (cmd === "exit") { setApp("mines", null); this.reset(); }
    else if (cmd === "best") openDialog("message", { title: "Fastest Mine Sweepers", text: ["Beginner", "Intermediate", "Expert"].map((s) => `${s}: ${this.options.best[s.toLowerCase()] ?? 999} seconds`).join("\n") });
  }

  menuItems(help) {
    if (help) return [
      { label: "&Contents", act: { run: ["app.help"] } },
      { sep: true },
      { label: "&About Mines...", act: { dialog: { kind: "message", title: "About Mines", text: "Mines\nHerdr 98\n\nFind all the mines without uncovering one.\nRight-click to mark a mine. Double-click a number to clear its neighbors." } } },
    ];
    const item = (name, cmd, extra = {}) => ({ label: name, ...extra, act: { shared: ["win98.mines.req", { cmd, t: Date.now() }] } });
    return [item("&New", "new", { shortcut: "F2" }), { sep: true },
      ...Object.keys(LEVELS).map((level) => item(`&${level[0].toUpperCase()}${level.slice(1)}`, level, { radio: level === this.options.level })),
      { sep: true }, item("&Marks (?)", "marks", { checked: this.options.marks }), item("&Color", "color", { checked: this.options.color }), item("&Sound", "sound", { checked: this.options.sound }),
      { sep: true }, item("&Best Times...", "best"), { sep: true }, item("E&xit", "exit")];
  }

  menuBar(u) {
    return own(h_flex().flex_none().h(u(18)).items_center().children(["&Game", "&Help"].map((name, i) =>
      bevel(u, shared("win98.menu.owner") === `mines-${i}` ? "well" : "flat", label(name), { pad: [0, 6] }).id(`mines-menu-${i}`).h(u(18)).justify_center()
        .on_mouse_down("left", (e, cx) => {
          cx.stop_propagation();
          const b = e.bounds;
          openMenu(this.menuItems(i === 1), b ? { x: b.x, y: b.y + b.height } : undefined, { owner: `mines-${i}` });
          cx.notify();
        }))));
  }

  cell(u, c, i) {
    const lost = this.state === "lost";
    const exposed = c.open || (lost && c.mine && c.mark !== 1);
    let content = null;
    if (lost && c.mark === 1 && !c.mine) content = art(u, "wrong");
    else if (c.mark === 1) content = art(u, "flag");
    else if (exposed && c.mine) content = art(u, "mine");
    else if (!exposed && c.mark === 2) content = div().font_weight(700).child("?");
    else if (c.open && c.n) content = div().font_family("Arial").font_weight(700).text_size(u(14)).line_height(`${u(14)}px`).text_color(this.options.color ? COLORS[c.n] : C.text).child(String(c.n));
    const down = this.held === i && c.mark !== 1 && !exposed;
    let cell = div().flex_none().w(u(16)).h(u(16)).flex().items_center().justify_center().bg(i === this.boom ? "#ff0000" : C.face);
    cell = cell.border_t(u(exposed || down ? 1 : 2)).border_l(u(exposed || down ? 1 : 2)).border_color(exposed || down ? C.shadow : C.hi)
      .child(div().absolute().right(0).bottom(0).w_full().h_full().border_r(u(exposed || down ? 0 : 2)).border_b(u(exposed || down ? 0 : 2)).border_color(C.shadow));
    return cell.relative().id(`mine-${i}`).when(Boolean(content), (el) => el.child(div().relative().flex_none().child(content)))
      .on_mouse_down("left", (_e, cx) => { cx.stop_propagation(); if (["ready", "playing"].includes(this.state)) this.held = i; cx.notify(); })
      .on_hover((hovered, cx) => { if (!hovered && this.held === i) { this.held = -1; cx.notify(); } })
      .on_click((e, cx) => {
        if (c.open && e.click_count >= 2) this.chord(i, cx);
        else this.reveal(i, cx);
        this.held = -1;
        cx.notify();
      })
      .on_mouse_down("right", (_e, cx) => {
        cx.stop_propagation();
        if (!c.open && ["ready", "playing"].includes(this.state)) c.mark = (c.mark + 1) % (this.options.marks ? 3 : 2);
        cx.notify();
      })
      .on_mouse_down("middle", (_e, cx) => { cx.stop_propagation(); this.held = i; cx.notify(); })
      .on_mouse_up("middle", (_e, cx) => { this.chord(i, cx); this.held = -1; cx.notify(); });
  }

  render(cx) {
    const req = shared("win98.mines.req");
    if (req && req.t !== this.req) { this.req = req.t; this.request(req.cmd); }
    if (apps().mines !== "open") return div();
    const u = unit();
    const face = this.state === "lost" ? "dead" : this.state === "won" ? "cool" : this.held >= 0 ? "ooh" : "smile";
    const flags = this.cells.filter((c) => c.mark === 1).length;
    const panel = bevel(u, "well", h_flex().h(u(33)).items_center().justify_between().px(u(5))
      .child(counter(u, this.total - flags))
      .child(button(u, "mines-face", art(u, `face-${face}`, 17), (_e, cx) => { this.reset(); cx.notify(); }, { w: 26, h: 26, pad: [0, 0] }))
      .child(counter(u, this.seconds)));
    const rows = v_flex().flex_none().children(Array.from({ length: this.rows }, (_v, y) => h_flex().flex_none().h(u(16)).children(this.cells.slice(y * this.cols, (y + 1) * this.cols).map((c, x) => this.cell(u, c, y * this.cols + x)))));
    const board = bevel(u, "pressed", rows, { pad: 1, bg: C.shadow }).flex_none();
    const body = own(v_flex().flex_none().p(u(5)).gap(u(6)).child(panel).child(board))
      .on_mouse_down_out((_e, cx) => { if (this.held >= 0) { this.held = -1; cx.notify(); } });
    return root(u, win(u, { id: "mines", title: "Mines", icon: icon(u, "mines", 16), w: this.cols * 16 + 22,
      controls: [["min", () => setApp("mines", "min"), "Minimize"], ["close", () => { setApp("mines", null); this.reset(); }, "Close"]],
      menu: this.menuBar(u), body,
    }));
  }
}
