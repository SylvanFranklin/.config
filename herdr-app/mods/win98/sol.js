import { div, image } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { shared, setShared, props, openOverlay, closeOverlay } from "herdr";
import { unit, scale, root, win, icon, own, button, label, bevel, well, apps, setApp, openMenu, openDialog, sfx } from "./kit.js";

const W = 596, H = 355, CW = 71, CH = 96;
const rank = c => c % 13 + 1;
const suit = c => Math.floor(c / 13);
const red = c => suit(c) < 2;
const req = cmd => ({ shared: ["win98.sol.req", { cmd, t: Date.now() }] });
const copy = x => JSON.parse(JSON.stringify(x));

export default class Solitaire {
  init(p, cx) {
    this.dialog = p.dialog;
    // A request from before this copy started was already handled.
    this.lastReq = shared("win98.sol.req")?.t;
    this.draw = shared("win98.sol.draw") ?? 3;
    this.scoring = shared("win98.sol.scoring") ?? true;
    this.deck = shared("win98.sol.deck") ?? 0;
    this.deal();
  }
  deal() {
    this.stop();
    const cards = Array.from({ length: 52 }, (_, i) => i);
    for (let i = 51; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [cards[i], cards[j]] = [cards[j], cards[i]];
    }
    this.g = { stock: cards, waste: [], tab: [], home: [[], [], [], []], score: 0 };
    for (let i = 0; i < 7; i++) this.g.tab.push(cards.splice(0, i + 1).map((c, j) => ({ c, up: j === i })));
    this.seconds = 0; this.running = false; this.won = false; this.undo = null;
    this.pick = null; this.press = null; this.drag = null; this.trails = [];
  }
  stop() {
    this.clock?.cancel(); this.clock = null;
    this.anim?.cancel(); this.anim = null;
  }
  begin(cx) {
    if (this.won || this.clock) return;
    this.running = true;
    this.clock = cx.timer.every(1000, cx => {
      this.seconds++;
      if (this.scoring && this.seconds % 10 === 0) this.g.score -= 2;
      cx.notify();
    });
  }
  save(cx) { this.undo = copy(this.g); this.begin(cx); }
  pile(loc) { return loc.type === "tab" ? this.g.tab[loc.i] : loc.type === "home" ? this.g.home[loc.i] : this.g.waste; }
  cards(loc) { return this.pile(loc).slice(loc.n).map(c => typeof c === "number" ? c : c.c); }
  validPick(loc) {
    const p = this.pile(loc);
    if (loc.n < 0 || !p.length) return false;
    if (loc.type !== "tab") return loc.n === p.length - 1;
    if (!p[loc.n].up) return false;
    for (let j = loc.n + 1; j < p.length; j++)
      if (!p[j].up || red(p[j].c) === red(p[j - 1].c) || rank(p[j].c) + 1 !== rank(p[j - 1].c)) return false;
    return true;
  }
  move(from, to, cx) {
    if (!from || !this.validPick(from) || (from.type === to.type && (from.i === to.i || to.type === "home"))) return false;
    const cards = this.cards(from), c = cards[0], dest = this.pile(to), last = dest[dest.length - 1];
    if (to.type === "home") {
      if (cards.length !== 1 || rank(c) !== dest.length + 1 || (last !== undefined && suit(last) !== suit(c))) return false;
    } else if (to.type === "tab") {
      if (!last ? rank(c) !== 13 : !last.up || red(last.c) === red(c) || rank(last.c) !== rank(c) + 1) return false;
    } else return false;
    this.save(cx);
    this.pile(from).splice(from.n);
    dest.push(...(to.type === "tab" ? cards.map(c => ({ c, up: true })) : cards));
    if (this.scoring) this.g.score += to.type === "home" ? 10 : from.type === "home" ? -15 : from.type === "waste" ? 5 : 0;
    this.pick = this.press = this.drag = null;
    if (this.g.home.every(p => p.length === 13)) this.victory(cx);
    cx.notify(); return true;
  }
  foundation(loc, cx) {
    if (!this.validPick(loc) || this.cards(loc).length !== 1) return;
    for (let i = 0; i < 4; i++) if (this.move(loc, { type: "home", i }, cx)) return;
  }
  stock(cx) {
    if (this.anim) { this.anim.cancel(); this.anim = null; cx.notify(); return; }
    if (this.won || (!this.g.stock.length && !this.g.waste.length)) return;
    this.save(cx); this.pick = null;
    if (this.g.stock.length) {
      for (let i = 0; i < this.draw && this.g.stock.length; i++) this.g.waste.push(this.g.stock.pop());
    } else { this.g.stock = this.g.waste.reverse(); this.g.waste = []; if (this.scoring) this.g.score -= this.draw === 1 ? 100 : 20; }
    cx.notify();
  }
  down(loc, e, cx) {
    cx.stop_propagation();
    if (this.anim) { this.anim.cancel(); this.anim = null; cx.notify(); return; }
    if (this.pick && this.move(this.pick, loc, cx)) return;
    if (loc.type === "tab" && this.pile(loc)[loc.n] && !this.pile(loc)[loc.n].up) {
      if (loc.n === this.pile(loc).length - 1) { this.save(cx); this.pile(loc)[loc.n].up = true; if (this.scoring) this.g.score += 5; cx.notify(); }
      return;
    }
    if (!this.validPick(loc)) { this.pick = null; cx.notify(); return; }
    this.press = { loc, x: e.position.x, y: e.position.y, dx: (e.local_position?.x ?? 0) / scale(), dy: (e.local_position?.y ?? 0) / scale() };
    cx.notify();
  }
  point(e) {
    const b = e.bounds;
    return { x: (e.position.x - b.x) / scale(), y: (e.position.y - b.y) / scale() };
  }
  target(x, y) {
    if (y < 116) { for (let i = 0; i < 4; i++) if (x >= 258 + i * 82 && x <= 329 + i * 82) return { type: "home", i }; }
    if (y >= 122) { const i = Math.floor((x - 12) / 82); if (i >= 0 && i < 7 && x <= 83 + i * 82) return { type: "tab", i }; }
    return null;
  }
  victory(cx) {
    this.stop(); this.won = true; this.running = false; this.pick = this.drag = this.press = null;
    sfx("tada"); this.trails = []; this.frame = 0; this.launched = 0; this.flying = null;
    this.anim = cx.timer.every(33, cx => {
      this.frame++;
      if (!this.flying) {
        if (this.launched === 52) { this.anim.cancel(); this.anim = null; cx.notify(); return; }
        const n = this.launched++;
        this.flying = { c: (n % 4) * 13 + 12 - Math.floor(n / 4), x: 258 + (n % 4) * 82, y: 10, vx: -3 - Math.random() * 4, vy: -2 };
      }
      const f = this.flying; f.x += f.vx; f.y += f.vy; f.vy += .7;
      if (f.y >= H - CH) { f.y = H - CH; f.vy = -Math.max(4, Math.abs(f.vy) * .8); }
      this.trails.push({ c: f.c, x: f.x, y: f.y });
      if (this.trails.length > 300) this.trails.shift();
      if (f.x < -CW) this.flying = null;
      if (this.frame > 5200) { this.anim.cancel(); this.anim = null; }
      cx.notify();
    });
  }
  open(kind) {
    openOverlay({ mod: "win98", kind: "dialog", modal: true, width: unit()(340), props: { role: "sol", dialog: kind } });
  }
  command(cmd, cx) {
    if (cmd === "deal") this.deal();
    if (cmd === "undo" && this.undo) { this.g = this.undo; this.undo = null; this.pick = this.drag = this.press = null; this.trails = []; this.stop(); this.won = false; this.begin(cx); }
    if (cmd === "options" || cmd === "deck") this.open(cmd);
    if (cmd === "exit") setApp("sol", null);
    if (cmd === "help") openDialog("message", { title: "Solitaire Help", text: "Build each suit from Ace to King in the four foundations. Build the columns down in alternating colors. Only a King can fill an empty column. Click or drag cards to move them. Double-click a card to send it home." });
    if (cmd === "about") openDialog("message", { title: "About Solitaire", text: "Solitaire\nHerdr 98\n\nKlondike. A little patience goes a long way." });
    if (cmd === "autowin") { this.g.home = Array.from({ length: 4 }, (_, s) => Array.from({ length: 13 }, (_, r) => s * 13 + r)); this.g.stock = []; this.g.waste = []; this.g.tab = Array.from({ length: 7 }, () => []); this.victory(cx); }
  }
  card(u, c, up = true, selected = false) {
    const file = up ? `${selected ? "select-" : ""}${suit(c)}-${rank(c)}` : `back-${this.deck}`;
    return div().relative().w(u(CW)).h(u(CH)).child(image(`mods/win98/img/sol-${file}.svg`).w(u(CW)).h(u(CH)));
  }
  dialogView(u, cx) {
    const kind = this.dialog, p = props();
    const choice = (text, selected, fn) => own(div().id(`sol-opt-${text}`).py(u(5)).child(`${selected ? "◉" : "○"}  ${text}`).on_click(fn));
    let body = v_flex().p(u(15)).gap(u(4));
    if (kind === "options") {
      body.child(div().font_weight(700).child("Draw"));
      for (const n of [1, 3]) body.child(choice(n === 1 ? "Draw One" : "Draw Three", this.draw === n, (_e, cx) => { this.draw = n; cx.notify(); }));
      body.child(div().mt(u(8)).font_weight(700).child("Scoring"));
      for (const v of [true, false]) body.child(choice(v ? "Standard" : "None", this.scoring === v, (_e, cx) => { this.scoring = v; cx.notify(); }));
    } else {
      body.child(div().child("Select a card back:"));
      body.child(h_flex().gap(u(14)).children([0, 1].map(n => {
        const old = this.deck; this.deck = n; const card = this.card(u, 0, false); this.deck = old;
        return own(div().id(`sol-deck-${n}`).p(u(3)).border(u(2)).border_color(this.deck === n ? "#000080" : "#c0c0c0").child(card).on_click((_e, cx) => { this.deck = n; cx.notify(); }));
      })));
    }
    body.child(h_flex().mt(u(12)).gap(u(8)).justify_end().child(button(u, "sol-ok", "OK", () => {
      setShared("win98.sol.draw", this.draw); setShared("win98.sol.scoring", this.scoring); setShared("win98.sol.deck", this.deck); closeOverlay(p.overlay);
    }, { w: 75, h: 23, default: true })).child(button(u, "sol-cancel", "Cancel", () => closeOverlay(p.overlay), { w: 75, h: 23 })));
    return root(u, win(u, { id: "sol-dialog", title: kind === "options" ? "Options" : "Select Card Back", body, controls: [["close", () => closeOverlay(p.overlay)]], w: 336 }));
  }
  render(cx) {
    const u = unit();
    if (this.dialog) return this.dialogView(u, cx);
    const request = shared("win98.sol.req");
    if (request && request.t !== this.lastReq) { this.lastReq = request.t; this.command(request.cmd, cx); }
    this.draw = shared("win98.sol.draw") ?? this.draw;
    this.scoring = shared("win98.sol.scoring") ?? this.scoring;
    this.deck = shared("win98.sol.deck") ?? this.deck;
    if (apps().sol !== "open") { this.stop(); this.drag = this.press = null; return div(); }
    if (this.running && !this.won && !this.clock) this.begin(cx);
    const menu = own(h_flex().h(u(19)).items_center().gap(u(2)));
    for (const name of ["Game", "Help"]) {
      const entries = name === "Game" ? [ ["&Deal", "deal"], null, ["&Undo", "undo"], ["&Deck...", "deck"], ["&Options...", "options"], null, ["E&xit", "exit"] ] : [["&Contents", "help"], ["&About Solitaire...", "about"]];
      menu.child(bevel(u, this.menu === name && shared("win98.menu.owner") === "sol" ? "pressed" : "flat", label(`&${name}`), { pad: [1, 6] }).id(`sol-menu-${name}`).on_mouse_down("left", (e, cx) => {
        cx.stop_propagation(); this.menu = name;
        openMenu(entries.map(it => it ? { label: it[0], act: req(it[1]), disabled: it[1] === "undo" && !this.undo } : { sep: true }), { x: e.bounds.x, y: e.bounds.y + e.bounds.height }, { owner: "sol" }); cx.notify();
      }));
    }
    const table = div().id("sol-table").relative().w(u(W)).h(u(H)).flex_none().bg("#008000").overflow_hidden()
      .on_mouse_down("left", (e, cx) => { cx.stop_propagation(); if (this.anim) { this.anim.cancel(); this.anim = null; cx.notify(); } })
      .on_hover((hovered, cx) => { if (!hovered && this.press) { this.press = this.drag = null; cx.notify(); } })
      .on_mouse_move((e, cx) => {
        if (!this.press) return;
        const p = this.point(e);
        if (this.drag || Math.abs(e.position.x - this.press.x) + Math.abs(e.position.y - this.press.y) > 4) {
          this.drag = { x: p.x - this.press.dx, y: p.y - this.press.dy }; this.pick = null; cx.notify();
        }
      }).on_mouse_up("left", (e, cx) => {
        if (!this.press) return;
        const from = this.press.loc;
        if (this.drag) { const p = this.point(e), to = this.target(p.x, p.y); if (to) this.move(from, to, cx); this.pick = null; }
        else this.pick = this.pick && JSON.stringify(this.pick) === JSON.stringify(from) ? null : from;
        this.press = this.drag = null; cx.notify();
      });
    const spot = (x, y) => div().absolute().left(u(x)).top(u(y)).w(u(CW)).h(u(CH)).border(u(1)).border_color("#004000").rounded(u(3));
    table.child(spot(12, 10).id("sol-stock").when(this.g.stock.length > 0, el => el.child(this.card(u, 0, false))).when(!this.g.stock.length, el => el.flex().items_center().justify_center().text_size(u(32)).text_color("#004000").child("↻")).on_mouse_down("left", (_e, cx) => { cx.stop_propagation(); this.stock(cx); }));
    const add = (loc, c, x, y, up = true) => {
      if (this.drag && this.press && this.press.loc.type === loc.type && this.press.loc.i === loc.i && loc.n >= this.press.loc.n) return;
      const selected = this.pick && this.pick.type === loc.type && this.pick.i === loc.i && loc.n >= this.pick.n;
      table.child(this.card(u, c, up, selected).absolute().left(u(x)).top(u(y)).id(`sol-${loc.type}-${loc.i}-${loc.n}`)
        .on_mouse_down("left", (e, cx) => this.down(loc, e, cx))
        .on_click((e, cx) => { cx.stop_propagation(); if (e.click_count >= 2 && up) { this.press = this.pick = null; this.foundation(loc, cx); } }));
    };
    const visible = Math.min(this.draw, this.g.waste.length);
    for (let j = this.g.waste.length - visible; j < this.g.waste.length; j++) add({ type: "waste", i: 0, n: j }, this.g.waste[j], 94 + (j - this.g.waste.length + visible) * 15, 10);
    for (let i = 0; i < 4; i++) {
      const p = this.g.home[i], loc = { type: "home", i, n: p.length - 1 };
      table.child(spot(258 + i * 82, 10).id(`sol-home-spot-${i}`).on_mouse_down("left", (e, cx) => this.down(loc, e, cx)));
      if (p.length) add(loc, p[p.length - 1], 258 + i * 82, 10);
    }
    for (let i = 0; i < 7; i++) {
      const p = this.g.tab[i]; let y = 126;
      table.child(spot(12 + i * 82, y).id(`sol-tab-spot-${i}`).on_mouse_down("left", (e, cx) => this.down({ type: "tab", i, n: 0 }, e, cx)));
      const faceCount = p.filter(c => c.up).length;
      const step = Math.min(18, (H - 126 - CH - (p.length - faceCount) * 7) / Math.max(1, faceCount - 1));
      p.forEach((c, n) => { add({ type: "tab", i, n }, c.c, 12 + i * 82, y, c.up); y += c.up ? Math.max(4, step) : 7; });
    }
    if (this.drag && this.press) this.cards(this.press.loc).forEach((c, i) => table.child(this.card(u, c).absolute().left(u(this.drag.x)).top(u(this.drag.y + i * 18))));
    for (const f of this.trails) table.child(this.card(u, f.c).absolute().left(u(f.x)).top(u(f.y)));
    const status = own(h_flex().h(u(19)).gap(u(2)).child(well(u, div().child(this.won ? "You won!" : "")).flex_1()).child(well(u, div().child(`Score: ${this.scoring ? this.g.score : 0}`)).w(u(95))).child(well(u, div().child(`Time: ${this.seconds}`)).w(u(95))));
    return root(u, win(u, { id: "sol", title: "Solitaire", icon: icon(u, "sol", 16), controls: [["min", () => setApp("sol", "min"), "Minimize"], ["close", () => setApp("sol", null), "Close"]], menu, body: table, status, w: 602 }));
  }
}
