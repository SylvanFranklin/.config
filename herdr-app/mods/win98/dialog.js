// Win98 dialogs, one overlay each: props { kind, ... }.
//   prompt    a name: { title, text, icon, value, command: { name, args }, machines }
//   confirm   { title, text, icon, buttons: [{ label, default, act }] }
//   message   { title, text, icon }
//   run       Run...: a command line in a new tab
//   shutdown  Shut Down Herdr: stand by, shut down, restart, MS-DOS mode
//   logoff    back to the main layout
//   about     About Herdr 98
//   taskman   Close Program: every terminal, End Task kills it
//   display   Display Properties: scale, desktop color, sounds, assistant
//   datetime  Date/Time Properties
//   mycomputer, network, bin: Explorer-ish windows
//   screen    the full-window shutdown / restart screens

import { div, svg, image } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import {
  props, closeOverlay, run, shared, setShared, terminals, spaces, agents, updates, hc, layout, openOverlay, home, settings,
} from "herdr";
import {
  C, ASSETS, FONT, DOS, unit, root, win, bevel, button, field, well, label, plain, icon, programIcon, sfx, perform, etch,
  scale, gradient, openDialog, dosPath, setApp,
} from "./kit.js";
import { userName } from "./taskbar.js";

const KIND_TITLE = {
  run: "Run",
  shutdown: "Shut Down Herdr",
  logoff: "Log Off Herdr",
  about: "About Herdr 98",
  taskman: "Close Program",
  display: "Display Properties",
  datetime: "Date/Time Properties",
  welcome: "Welcome to Herdr 98",
  mycomputer: "My Computer",
  network: "Network Neighborhood",
  bin: "Recycle Bin",
};

function lines(text) {
  return String(text ?? "")
    .split("\n")
    .map((l) => div().child(l || " "));
}

export default class Dialog {
  init(p, cx) {
    this.p = p;
    this.kind = p.kind;
    this.focus = cx.focus_handle();
    this.focus.focus();
    this.text = p.value ?? "";
    this.fresh = true;
    this.choice = 0;
    this.sel = 0;
    this.page = 0;
    this.machines = [];
    this.machine = null;
    if (this.kind === "run" && p.value === undefined) {
      const hist = shared("win98.run") ?? [];
      this.text = hist[0] ?? "";
    }
    if (this.kind === "confirm" || this.kind === "message") sfx(p.icon === "error" ? "chord" : p.icon === "question" ? "ding" : "ding");
    if (this.kind === "shutdown" || this.kind === "logoff") sfx("ding");
    if ((this.kind === "prompt" && p.machines) || this.kind === "network")
      cx.spawn(async (cx) => {
        try {
          const r = await hc(["machine", "ls", "--json"]);
          this.machines = r.code === 0 ? (JSON.parse(r.stdout).machines ?? []).filter((m) => !m.temporary) : [];
        } catch {}
        cx.notify();
      });
    if (this.kind === "screen") this.screen(cx);
    if (this.kind === "datetime") cx.timer.every(1000, (cx) => cx.notify());
  }

  close() {
    closeOverlay(props().overlay);
  }

  // ---- the shutdown and restart screens

  screen(cx) {
    const mode = this.p.mode;
    this.stage = 0;
    if (mode === "boot") {
      this.stage = 1;
      sfx("startup");
      cx.timer.after(3400, () => {
        this.close();
        if (shared("win98.welcome") !== "off") openDialog("welcome", {});
      });
    } else if (mode === "shutdown") {
      sfx("shutdown");
      cx.timer.after(2600, (cx) => {
        this.stage = 1;
        cx.notify();
        cx.timer.after(1600, () => {
          this.close();
          run("window.close", {});
        });
      });
    } else {
      cx.timer.after(1200, (cx) => {
        this.stage = 1;
        sfx("startup");
        cx.notify();
        cx.timer.after(3200, () => this.close());
      });
    }
  }

  renderScreen(u) {
    if (this.p.mode === "shutdown" && this.stage === 1)
      return div()
        .size_full()
        .bg("#000000")
        .flex()
        .items_center()
        .justify_center()
        .child(
          v_flex()
            .items_center()
            .font_family(DOS)
            .text_size(u(32))
            .line_height(`${u(40)}px`)
            .text_color("#ff9c00")
            .child("It's now safe to turn off")
            .child("your computer."),
        );
    const msg = this.p.mode === "shutdown" || this.stage === 0 ? "Herdr is shutting down..." : "Starting Herdr 98...";
    return div()
      .size_full()
      .relative()
      .bg("#000000")
      .child(image(`${ASSETS}/img/splash.png`).absolute().top(0).left(0).size_full())
      .child(
        div()
          .absolute()
          .bottom(u(40))
          .left(0)
          .w_full()
          .flex()
          .justify_center()
          .text_size(u(14))
          .font_weight(700)
          .text_color(C.white)
          .child(msg),
      );
  }

  // ---- keys

  key(e, cx) {
    const m = e.modifiers;
    if (this.kind === "screen") return cx.stop_propagation();
    if (e.key === "escape") {
      this.close();
      return cx.stop_propagation();
    }
    if (e.key === "enter" && this.kind !== "welcome") {
      this.ok();
      return cx.stop_propagation();
    }
    if (this.kind === "prompt" || this.kind === "run") {
      if (e.key === "backspace") this.text = this.fresh ? "" : this.text.slice(0, -1);
      else if (m.control && e.key === "u") this.text = "";
      else if (m.control && e.key === "w") this.text = this.text.replace(/\S+\s*$/, "");
      else if (m.control && e.key === "a") this.fresh = true;
      else if (e.key_char && !m.control && !m.platform) this.text = (this.fresh ? "" : this.text) + e.key_char;
      else if (e.key === "left" && this.machines.length) this.pickMachine(-1);
      else if (e.key === "right" && this.machines.length) this.pickMachine(1);
      else return;
      if (!(m.control && e.key === "a")) this.fresh = false;
    } else if (this.kind === "shutdown" || this.kind === "taskman") {
      const n = this.kind === "shutdown" ? 4 : this.tasks().length;
      if (e.key === "down") (this.kind === "shutdown" ? (this.choice = (this.choice + 1) % n) : (this.sel = Math.min(n - 1, this.sel + 1)));
      else if (e.key === "up") (this.kind === "shutdown" ? (this.choice = (this.choice + n - 1) % n) : (this.sel = Math.max(0, this.sel - 1)));
      else return;
    } else return;
    cx.stop_propagation();
    cx.notify();
  }

  pickMachine(d) {
    const all = [null, ...this.machines.map((x) => x.name)];
    this.machine = all[(all.indexOf(this.machine) + d + all.length) % all.length];
  }

  ok() {
    const p = this.p;
    switch (this.kind) {
      case "prompt": {
        const name = this.text.trim();
        if (!name) return;
        this.close();
        run(p.command.name, { ...(p.command.args ?? {}), name, ...(p.machines ? { machine: this.machine ?? "" } : {}) });
        return;
      }
      case "run":
        return this.runIt();
      case "confirm": {
        const b = (p.buttons ?? []).find((x) => x.default) ?? p.buttons?.[0];
        this.close();
        perform(b?.act);
        return;
      }
      case "shutdown":
        return this.shutdown();
      case "logoff":
        this.close();
        run("layout.switch", { name: "main" });
        return;
      case "taskman":
        return this.endTask();
      default:
        this.close();
    }
  }

  runIt() {
    const cmd = this.text.trim();
    if (!cmd) return;
    const hist = [cmd, ...(shared("win98.run") ?? []).filter((c) => c !== cmd)].slice(0, 12);
    setShared("win98.run", hist);
    this.close();
    const name = cmd.split(/\s+/)[0].split("/").pop();
    run("tab.new", { name, argv: ["sh", "-c", `${cmd}\nexec "\${SHELL:-sh}"`] });
  }

  shutdown() {
    const c = this.choice;
    this.close();
    if (c === 0) {
      // Stand by: every tab of the shown space to the taskbar.
      const s = spaces().find((x) => x.active);
      for (const t of s?.tabs ?? []) if (!t.settled) run("tab.settle", { id: t.id });
    } else if (c === 1) {
      openOverlay({ mod: "win98", kind: "dialog", frame: "none", modal: true, width: 1, height: 1, props: { role: "dialog", kind: "screen", mode: "shutdown" } });
    } else if (c === 2) {
      openOverlay({ mod: "win98", kind: "dialog", frame: "none", modal: true, width: 1, height: 1, props: { role: "dialog", kind: "screen", mode: "restart" } });
    } else {
      run("layout.switch", { name: "terminals" });
    }
  }

  tasks() {
    return terminals()
      .filter((t) => t.state !== "finished")
      .map((t) => ({ address: t.address, name: t.program?.name ?? t.name ?? t.address, program: t.program, status: t.status }));
  }

  endTask() {
    const t = this.tasks()[this.sel];
    if (!t) return;
    run("terminal.kill", { terminal: t.address });
    sfx("chord");
    this.sel = Math.max(0, this.sel - 1);
  }

  // ---- pieces

  btn(u, id, text, fn, o = {}) {
    return button(u, `dlg-${id}`, text, fn, { w: 75, h: 23, ...o });
  }

  buttons(u, list, align = "center") {
    return h_flex()
      .w_full()
      .gap(u(6))
      .map((el) => (align === "end" ? el.justify_end() : el.justify_center()))
      .children(list);
  }

  input(u, value) {
    return field(
      u,
      h_flex()
        .h(u(15))
        .items_center()
        .overflow_hidden()
        .child(div().when(this.fresh && Boolean(value), (el) => el.bg(C.select).text_color(C.selectText)).child(value))
        .child(div().w(u(1)).h(u(13)).bg(C.text).loop("opacity", { from: 0, to: 1, period: 1060 })),
    ).w_full();
  }

  radio(u, id, text, on, fn) {
    const dot = image(`${ASSETS}/icons/radio-${on ? "on" : "off"}.svg`).flex_none().w(u(12)).h(u(12));
    return h_flex()
      .id(`radio-${id}`)
      .gap(u(6))
      .items_center()
      .on_click((_e, cx) => {
        fn();
        cx.notify();
      })
      .child(dot)
      .child(label(text));
  }

  check(u, id, text, on, fn) {
    const box = bevel(u, "field", div().size_full().flex().items_center().justify_center().when(on, (el) => el.child(svg(`${ASSETS}/icons/check.svg`).w(u(7)).h(u(7)).text_color(C.text))), { bg: C.white })
      .w(u(13))
      .h(u(13))
      .flex_none();
    return h_flex()
      .id(`check-${id}`)
      .gap(u(6))
      .items_center()
      .on_click((_e, cx) => {
        fn();
        cx.notify();
      })
      .child(box)
      .child(label(text));
  }

  frame(u, title, body, o = {}) {
    const controls = o.help === false ? [] : [["help", () => {}, "Help"]];
    controls.push(["close", () => this.close(), "Close"]);
    return win(u, {
      id: "dlg",
      title,
      icon: o.icon,
      controls,
      body,
      status: o.status,
    });
  }

  // ---- kinds

  renderPrompt(u) {
    const p = this.p;
    const chips = this.machines.length
      ? v_flex()
          .gap(u(4))
          .child(label("Computer:"))
          .child(
            h_flex()
              .gap(u(10))
              .flex_wrap()
              .children([null, ...this.machines.map((m) => m.name)].map((m, i) =>
                this.radio(u, `m${i}`, m ?? "This computer", this.machine === m, () => (this.machine = m)),
              )),
          )
      : null;
    return v_flex()
      .p(u(10))
      .gap(u(10))
      .child(
        h_flex()
          .gap(u(12))
          .items_start()
          .child(icon(u, p.icon ?? "folder", 32))
          .child(v_flex().flex_1().gap(u(8)).child(v_flex().children(lines(p.text))).child(this.input(u, this.text))),
      )
      .when(Boolean(chips), (el) => el.child(div().pl(u(44)).child(chips)))
      .child(this.buttons(u, [this.btn(u, "ok", "OK", () => this.ok(), { default: true }), this.btn(u, "cancel", "Cancel", () => this.close())], "end"));
  }

  renderConfirm(u) {
    const p = this.p;
    const bs = p.buttons ?? [{ label: "OK", default: true }];
    return v_flex()
      .p(u(12))
      .gap(u(14))
      .child(
        h_flex()
          .gap(u(14))
          .items_start()
          .when(Boolean(p.icon), (el) => el.child(icon(u, p.icon, 32)))
          .child(v_flex().flex_1().pt(u(6)).children(lines(p.text))),
      )
      .child(
        this.buttons(
          u,
          bs.map((b, i) =>
            this.btn(u, `b${i}`, b.label, () => {
              this.close();
              perform(b.act);
            }, { default: b.default }),
          ),
        ),
      );
  }

  renderRun(u) {
    return v_flex()
      .p(u(10))
      .gap(u(12))
      .child(
        h_flex()
          .gap(u(12))
          .items_start()
          .child(icon(u, "run", 32))
          .child(v_flex().flex_1().children(lines("Type the name of a program, and Herdr will\nopen it for you in a new window."))),
      )
      .child(
        h_flex()
          .gap(u(8))
          .items_center()
          .child(div().w(u(32)).child(label("&Open:")))
          .child(
            h_flex()
              .flex_1()
              .child(div().flex_1().child(this.input(u, this.text)))
              .child(button(u, "dlg-hist", svg(`${ASSETS}/icons/arrow-down.svg`).w(u(7)).h(u(4)).text_color(C.text), () => {
                const hist = shared("win98.run") ?? [];
                const i = hist.indexOf(this.text);
                this.text = hist[(i + 1) % Math.max(1, hist.length)] ?? "";
                this.fresh = true;
              }, { w: 16, h: 21, pad: [0, 0] })),
          ),
      )
      .child(
        this.buttons(u, [
          this.btn(u, "ok", "OK", () => this.ok(), { default: true }),
          this.btn(u, "cancel", "Cancel", () => this.close()),
          this.btn(u, "browse", "&Browse...", null, { disabled: true }),
        ], "end"),
      );
  }

  renderShutdown(u) {
    const opts = ["&Stand by", "Sh&ut down", "&Restart", "Restart in &DOS mode"];
    return v_flex()
      .p(u(10))
      .gap(u(12))
      .child(
        h_flex()
          .gap(u(14))
          .items_start()
          .child(icon(u, "shutdown", 32))
          .child(
            v_flex()
              .gap(u(8))
              .child("What do you want the computer to do?")
              .children(opts.map((o, i) => this.radio(u, `sd${i}`, o, this.choice === i, () => (this.choice = i)))),
          ),
      )
      .child(
        this.buttons(u, [
          this.btn(u, "ok", "OK", () => this.ok(), { default: true }),
          this.btn(u, "cancel", "Cancel", () => this.close()),
          this.btn(u, "help", "&Help", () => run("app.help", {})),
        ]),
      );
  }

  renderLogoff(u) {
    return v_flex()
      .p(u(12))
      .gap(u(14))
      .child(h_flex().gap(u(14)).items_center().child(icon(u, "logoff", 32)).child("Are you sure you want to log off?"))
      .child(this.buttons(u, [this.btn(u, "yes", "&Yes", () => this.ok(), { default: true }), this.btn(u, "no", "&No", () => this.close())]));
  }

  renderAbout(u) {
    const up = updates();
    const n = terminals().length;
    const a = agents().length;
    return v_flex()
      .p(u(10))
      .gap(u(10))
      .child(image(`${ASSETS}/img/about.png`).w(u(356)).h(u(80)))
      .child(
        h_flex()
          .gap(u(14))
          .items_start()
          .child(icon(u, "computer", 32))
          .child(
            v_flex()
              .flex_1()
              .gap(u(2))
              .child("Herdr 98")
              .child(`Version ${up?.app?.version ?? "4.10.1998"} Second Edition`)
              .child("Copyright \u00a9 1981-2026 The Herd Corp.")
              .child(div().h(u(6)))
              .child("This product is licensed to:")
              .child(div().pl(u(12)).child(userName()))
              .child(div().pl(u(12)).child("Personal Use Edition"))
              .child(div().h(u(6)))
              .child(etch(u))
              .child(div().h(u(4)))
              .child(`Terminals running:  ${n}`)
              .child(`Agents at work:  ${a}`)
              .child(`herdr-core:  ${up?.core?.version ?? "?"}`)
              .child("Physical memory available to agents:  64.0 MB RAM"),
          ),
      )
      .child(this.buttons(u, [this.btn(u, "ok", "OK", () => this.close(), { default: true })], "end"));
  }

  renderTaskman(u) {
    const tasks = this.tasks();
    if (this.sel >= tasks.length) this.sel = Math.max(0, tasks.length - 1);
    const list = v_flex()
      .id("tasks")
      .h(u(150))
      .overflow_y_scroll()
      .children(
        tasks.map((t, i) =>
          h_flex()
            .id(`task-${t.address}`)
            .h(u(16))
            .px(u(2))
            .gap(u(4))
            .items_center()
            .when(i === this.sel, (el) => el.bg(C.select).text_color(C.selectText))
            .on_click((e, cx) => {
              this.sel = i;
              if (e.click_count >= 2) {
                this.close();
                run("agent.focus", { terminal: t.address });
              }
              cx.notify();
            })
            .child(programIcon(u, t.program, 16))
            .child(div().flex_1().truncate().child(`${t.name}${t.status ? ` (${t.status})` : ""}`))
            .child(div().text_color(i === this.sel ? C.selectText : C.gray).child(t.address)),
        ),
      );
    return v_flex()
      .p(u(10))
      .gap(u(10))
      .child(field(u, list, { pad: [1, 1] }))
      .child(
        v_flex()
          .children(lines("WARNING: Pressing CTRL+ALT+DEL again will restart your\ncomputer. You will lose unsaved information in all\nprograms that are running.")),
      )
      .child(
        this.buttons(u, [
          this.btn(u, "end", "&End Task", () => this.endTask(), { default: true }),
          this.btn(u, "sd", "Sh&ut Down", () => {
            this.close();
            openDialog("shutdown", {});
          }),
          this.btn(u, "cancel", "Cancel", () => this.close()),
        ]),
      );
  }

  renderDisplay(u) {
    const tabs = ["Background", "Effects", "Settings"];
    const tabRow = h_flex()
      .items_end()
      .pl(u(4))
      .children(
        tabs.map((t, i) => {
          const on = i === this.page;
          return div()
            .id(`dtab-${i}`)
            .relative()
            .top(on ? u(1) : u(0))
            .on_click((_e, cx) => {
              this.page = i;
              cx.notify();
            })
            .child(
              div()
                .border_t(u(1))
                .border_l(u(1))
                .border_r(u(1))
                .border_color(C.hi)
                .child(
                  div()
                    .border_r(u(1))
                    .border_color(C.dark)
                    .bg(C.face)
                    .px(u(on ? 8 : 6))
                    .py(u(on ? 3 : 2))
                    .child(label(t)),
                ),
            );
        }),
      );
    const desktop = shared("win98.desktop") ?? "#008080";
    const colors = [["(None)", "#008080"], ["Black", "#000000"], ["Navy", "#000080"], ["Plum", "#5c3566"], ["Forest", "#004000"], ["Clouds", "clouds"]];
    const scaleNow = scale();
    const page = [
      v_flex()
        .gap(u(8))
        .child(
          h_flex()
            .justify_center()
            .child(
              div()
                .relative()
                .w(u(184))
                .h(u(170))
                .child(image(`${ASSETS}/img/monitor.png`).absolute().top(0).left(0).w(u(184)).h(u(170)))
                .child(
                  div()
                    .absolute()
                    .left(u(17))
                    .top(u(16))
                    .w(u(152))
                    .h(u(112))
                    .bg(desktop === "clouds" ? "#6fa8dc" : desktop)
                    .when(desktop === "clouds", (el) => el.child(image(`${ASSETS}/img/clouds.png`).size_full())),
                ),
            ),
        )
        .child(label("&Wallpaper:"))
        .child(
          field(
            u,
            v_flex().children(
              colors.map(([n, c]) =>
                h_flex()
                  .id(`bg-${n}`)
                  .h(u(16))
                  .px(u(2))
                  .items_center()
                  .when(desktop === c, (el) => el.bg(C.select).text_color(C.selectText))
                  .on_click(() => setDesktop(c))
                  .child(n),
              ),
            ),
            { pad: [1, 1] },
          ),
        ),
      v_flex()
        .gap(u(10))
        .p(u(6))
        .child(this.check(u, "snd", "Play &sounds (startup, dialogs, games)", shared("win98.mute") !== true, () => setShared("win98.mute", shared("win98.mute") !== true)))
        .child(this.check(u, "clippy", "Show the &Office Assistant", shared("win98.clippy") !== "off", () => setShared("win98.clippy", shared("win98.clippy") === "off" ? "on" : "off")))
        .child(etch(u))
        .child(v_flex().text_color(C.gray).children(lines("Sounds also follow Herdr's own setting\n(Control Panel > Alerts)."))),
      v_flex()
        .gap(u(10))
        .p(u(6))
        .child(label("Font size:"))
        .child(this.radio(u, "s1", "&Small Fonts (pixel perfect)", scaleNow === 1, () => setShared("win98.scale", 1)))
        .child(this.radio(u, "s2", "&Large Fonts (every pixel doubled)", scaleNow === 2, () => setShared("win98.scale", 2)))
        .child(etch(u))
        .child(v_flex().text_color(C.gray).children(lines(`Herdr's zoom is ${settings()?.zoom ?? 1}x; Herdr 98 draws whole\npixels at any zoom.`))),
    ][this.page];
    return v_flex()
      .p(u(8))
      .gap(u(0))
      .child(tabRow)
      .child(bevel(u, "window", div().p(u(10)).min_h(u(300)).child(page), { bg: C.face }))
      .child(div().h(u(10)))
      .child(
        this.buttons(u, [
          this.btn(u, "ok", "OK", () => this.close(), { default: true }),
          this.btn(u, "cancel", "Cancel", () => this.close()),
          this.btn(u, "apply", "&Apply", null, { disabled: true }),
        ], "end"),
      );
  }

  renderDatetime(u) {
    const d = new Date();
    const y = d.getFullYear();
    const mo = d.getMonth();
    const first = new Date(y, mo, 1).getDay();
    const days = new Date(y, mo + 1, 0).getDate();
    const cells = [];
    for (let i = 0; i < first; i++) cells.push(null);
    for (let i = 1; i <= days; i++) cells.push(i);
    while (cells.length % 7) cells.push(null);
    const weeks = [];
    for (let i = 0; i < cells.length; i += 7) weeks.push(cells.slice(i, i + 7));
    const cal = v_flex()
      .bg(C.white)
      .child(h_flex().bg(C.gray).text_color(C.white).children(["S", "M", "T", "W", "T", "F", "S"].map((x) => div().w(u(22)).flex().justify_center().child(x))))
      .children(
        weeks.map((w) =>
          h_flex().children(
            w.map((n) =>
              div()
                .w(u(22))
                .h(u(16))
                .flex()
                .items_center()
                .justify_center()
                .when(n === d.getDate(), (el) => el.bg(C.select).text_color(C.selectText))
                .child(n ? String(n) : ""),
            ),
          ),
        ),
      );
    const month = d.toLocaleDateString("en-US", { month: "long" });
    const time = d.toLocaleTimeString("en-US");
    return v_flex()
      .p(u(10))
      .gap(u(10))
      .child(
        h_flex()
          .gap(u(12))
          .items_start()
          .child(
            v_flex()
              .gap(u(6))
              .child(h_flex().gap(u(6)).child(field(u, div().w(u(80)).child(month))).child(field(u, div().w(u(40)).child(String(y)))))
              .child(field(u, cal, { pad: [0, 0] })),
          )
          .child(v_flex().gap(u(6)).items_center().child(clockFace(u, d)).child(field(u, div().w(u(90)).flex().justify_center().child(time)))),
      )
      .child(div().child(`Time zone: ${Intl.DateTimeFormat().resolvedOptions().timeZone}`))
      .child(this.buttons(u, [this.btn(u, "ok", "OK", () => this.close(), { default: true }), this.btn(u, "cancel", "Cancel", () => this.close())], "end"));
  }

  explorer(u, items, status) {
    const grid = h_flex()
      .flex_wrap()
      .gap(u(8))
      .p(u(8))
      .items_start()
      .children(
        items.map((it, i) =>
          v_flex()
            .id(`ex-${i}`)
            .w(u(76))
            .items_center()
            .gap(u(2))
            .on_click((e, cx) => {
              this.sel = i;
              if (it.act) {
                this.close();
                perform(it.act);
              }
              cx.notify();
            })
            .child(it.img ? image(it.img).w(u(32)).h(u(32)) : icon(u, it.icon, 32))
            .child(
              div()
                .px(u(1))
                .text_center()
                .when(i === this.sel, (el) => el.bg(C.select).text_color(C.selectText))
                .child(it.label),
            ),
        ),
      );
    return v_flex()
      .child(
        field(
          u,
          div()
            .h(u(200))
            .id("ex-scroll")
            .overflow_y_scroll()
            .child(items.length ? grid : div().p(u(10)).text_color(C.gray).child("This folder is empty.")),
          { pad: [0, 0] },
        ),
      )
      .child(h_flex().pt(u(2)).gap(u(2)).child(well(u, div().child(status)).flex_1()).child(well(u, h_flex().gap(u(4)).child(icon(u, "computer", 16)).child("My Computer")).w(u(120))));
  }

  renderMyComputer(u) {
    const letters = "CDEFGHIJKLMNOPQRSTUVWXYZ";
    const items = spaces().map((s, i) => ({
      label: `${s.name} (${letters[i] ?? "Z"}:)`,
      icon: s.machine ? "netdrive" : "drive",
      act: { run: ["space.select", { id: s.id }] },
    }));
    items.push({ label: "Control Panel", icon: "control", act: { run: ["app.settings", {}] } });
    items.push({ label: "Printers", icon: "printer", act: { dialog: { kind: "message", title: "Printers", icon: "error", text: "There are no printers installed.\nPrinting a terminal is a choice, not a feature." } } });
    return this.explorer(u, items, `${items.length} object(s)`);
  }

  renderNetwork(u) {
    const items = [
      { label: "Entire Network", icon: "network", act: null },
      { label: "This computer", icon: "computer", act: { dialog: { kind: "prompt", title: "New Space", text: "Type a name for the new space:", icon: "folder", command: { name: "space.new", args: { machine: "" } } } } },
      ...this.machines.map((m) => ({
        label: m.name,
        icon: "computer",
        act: { dialog: { kind: "prompt", title: `New Space on ${m.name}`, text: `Type a name for the new space on ${m.name}:`, icon: "netdrive", command: { name: "space.new", args: { machine: m.name } } } },
      })),
    ];
    return this.explorer(u, items, `${items.length} object(s)`);
  }

  renderWelcome(u) {
    const items = [
      { icon: "programs", title: "Begin an Agent", text: "Herdr runs your coding agents in windows,\nlike it's 1998 and the future at once.\n\nStart one from Start > Programs > Agents,\nor open the Run box and type its name.", go: "&Run...", act: { dialog: { kind: "run", value: "claude" } } },
      { icon: "help", title: "Discover Herdr 98", text: "The taskbar is your tabs. The folders on\nthe desktop are your spaces. Each window\nis a pane: double-click its title bar to\nmaximize it, or use _ to minimize the tab.\n\nCtrl+Esc opens the Start menu.", go: "&Help", act: { run: ["app.help", {}] } },
      { icon: "mines", title: "Play Mines", text: "Your agent is thinking.\nYou've earned a break.\n\nSolitaire is on the desktop too.", go: "&Play", act: { app: "mines" } },
      { icon: "taskman", title: "Maintain Your Computer", text: "See every program Herdr runs, and end\nthe ones you don't need anymore.\n\nCtrl+Shift+Esc opens it anytime.", go: "&Open", act: { dialog: { kind: "taskman" } } },
      { icon: "logoff", title: "Leave Herdr 98", text: "Miss the future? Log Off takes you\nback to Herdr's normal layout.\nYour terminals keep running.", go: "&Log Off", act: { dialog: { kind: "logoff" } } },
    ];
    const it = items[this.sel] ?? items[0];
    const show = shared("win98.welcome") !== "off";
    return v_flex()
      .child(
        div()
          .relative()
          .h(u(56))
          .flex()
          .items_center()
          .px(u(16))
          .child(gradient("#ffffff", "#6aa6e8"))
          .child(
            h_flex()
              .relative()
              .items_end()
              .gap(u(6))
              .child(icon(u, "start", 32))
              .child(div().text_size(u(22)).line_height(`${u(26)}px`).text_color(C.navy).child("Welcome to"))
              .child(div().text_size(u(22)).line_height(`${u(26)}px`).font_weight(700).text_color(C.text).child("Herdr"))
              .child(div().text_size(u(22)).line_height(`${u(26)}px`).text_color("#d07000").child("98")),
          ),
      )
      .child(
        h_flex()
          .items_stretch()
          .h(u(230))
          .child(
            v_flex()
              .w(u(190))
              .p(u(8))
              .gap(u(2))
              .bg("#000080")
              .child(div().pb(u(4)).text_color("#ffff80").font_weight(700).child("CONTENTS"))
              .children(
                items.map((x, i) =>
                  h_flex()
                    .id(`wl-${i}`)
                    .gap(u(8))
                    .p(u(3))
                    .items_center()
                    .text_color(i === this.sel ? "#ffff80" : C.white)
                    .on_mouse_move((_e, cx) => {
                      if (this.sel === i) return;
                      this.sel = i;
                      cx.notify();
                    })
                    .on_click(() => {
                      this.close();
                      perform(x.act);
                    })
                    .child(icon(u, x.icon, 32))
                    .child(div().when(i === this.sel, (el) => el.underline()).child(x.title)),
                ),
              ),
          )
          .child(
            v_flex()
              .flex_1()
              .p(u(14))
              .gap(u(10))
              .bg(C.white)
              .child(div().text_size(u(16)).line_height(`${u(20)}px`).font_weight(700).text_color(C.navy).child(it.title))
              .child(v_flex().children(lines(it.text)))
              .child(div().flex_1())
              .child(h_flex().justify_end().child(this.btn(u, "go", it.go, () => {
                this.close();
                perform(it.act);
              }, { default: true }))),
          ),
      )
      .child(etch(u))
      .child(
        h_flex()
          .p(u(8))
          .justify_between()
          .items_center()
          .child(this.check(u, "wl-show", "&Show this screen each time Herdr 98 starts", show, () => setShared("win98.welcome", show ? "off" : "on")))
          .child(this.btn(u, "close", "&Close", () => this.close())),
      );
  }

  renderBin(u) {
    return v_flex()
      .child(this.explorer(u, [], "0 object(s)"))
      .child(div().h(u(8)))
      .child(this.buttons(u, [this.btn(u, "empty", "&Empty Recycle Bin", () => sfx("recycle"), { w: 120 })], "end"));
  }

  render(_cx) {
    const u = unit();
    const p = this.p;
    if (this.kind === "screen")
      return root(u, div().id("screen").track_focus(this.focus).on_key_down((e, cx) => this.key(e, cx)).size_full()).child(this.renderScreen(u));
    const body =
      {
        prompt: () => this.renderPrompt(u),
        confirm: () => this.renderConfirm(u),
        message: () => this.renderConfirm(u),
        run: () => this.renderRun(u),
        shutdown: () => this.renderShutdown(u),
        logoff: () => this.renderLogoff(u),
        about: () => this.renderAbout(u),
        taskman: () => this.renderTaskman(u),
        display: () => this.renderDisplay(u),
        datetime: () => this.renderDatetime(u),
        mycomputer: () => this.renderMyComputer(u),
        network: () => this.renderNetwork(u),
        bin: () => this.renderBin(u),
        welcome: () => this.renderWelcome(u),
      }[this.kind]?.() ?? div().p(u(10)).child(`Unknown dialog ${this.kind}`);
    const explorerish = ["mycomputer", "network", "bin"].includes(this.kind);
    const iconFor = { mycomputer: "computer", network: "network", bin: "bin", display: "display", run: "run", taskman: "taskman", datetime: "clock" }[this.kind];
    return root(
      u,
      v_flex()
        .id("dialog")
        .track_focus(this.focus)
        .on_key_down((e, cx) => this.key(e, cx))
        .w_full()
        .min_h(0),
    ).child(
      this.frame(u, p.title ?? KIND_TITLE[this.kind] ?? "Herdr", body, {
        icon: iconFor ? icon(u, iconFor, 16) : null,
        help: !explorerish,
      }),
    );
  }
}

function setDesktop(c) {
  setShared("win98.desktop", c);
  const l = layout();
  if (!l || typeof l !== "object") return;
  l.background = c === "clouds" ? { image: `${ASSETS}/img/clouds.png`, fit: "cover" } : c;
  run("layout.set", { layout: l });
}

function clockFace(u, d) {
  const size = 96;
  // GPUI can't rotate a div: draw the hands as dots along their angle.
  const dots = (deg, len, sizeDot, color) => {
    const out = [];
    const r = (deg * Math.PI) / 180;
    for (let i = 0; i < len; i += sizeDot) {
      const x = size / 2 + Math.sin(r) * i - sizeDot / 2;
      const y = size / 2 - Math.cos(r) * i - sizeDot / 2;
      out.push(div().absolute().left(u(Math.round(x))).top(u(Math.round(y))).w(u(sizeDot)).h(u(sizeDot)).bg(color));
    }
    return out;
  };
  const ticks = [];
  for (let i = 0; i < 12; i++) {
    const r = (i * 30 * Math.PI) / 180;
    const x = size / 2 + Math.sin(r) * 40 - 2;
    const y = size / 2 - Math.cos(r) * 40 - 2;
    ticks.push(div().absolute().left(u(Math.round(x))).top(u(Math.round(y))).w(u(4)).h(u(4)).bg(i % 3 === 0 ? C.navy : "#008080"));
  }
  const h = d.getHours() % 12;
  const m = d.getMinutes();
  const s = d.getSeconds();
  return div()
    .relative()
    .w(u(size))
    .h(u(size))
    .children(ticks)
    .children(dots(h * 30 + m / 2, 24, 3, C.text))
    .children(dots(m * 6, 34, 2, C.text))
    .children(dots(s * 6, 36, 1, "#ff0000"));
}
