// First-run welcome over the live app; records finished/skipped in frame.welcomed.

import { View, div, svg, image } from "gpui-kit";
import { v_flex, h_flex, Scrollbar } from "gpui-base";
import { spaces, run, theme, props, closeOverlay, setShared, shared, hc, appHome, readTextFile, writeTextFile, settings, layout, keys } from "herdr";

const I = (name) => `frame/welcome/${name}.svg`;
const W = (name) => `mods/workspace-chrome/${name}.svg`;
const PAGES = 4;
const ASK = "Read ~/.config/herdr-app/AGENTS.md, then tell me what you can change in Herdr.";
const MIGRATE = "Read `herdr-app --skill`, then migrate my keybinds and settings from ~/.config/herdr/config.toml";
const APPEARANCES = [
  [null, "System"],
  ["light", "Light"],
  ["dark", "Dark"],
];
// The panels the layout offers (its "panel-body" stack), as the tab bar's buttons.
const PANELS = [
  { id: "files", icon: "files", title: "Files", about: "The folder you're in as a tree. Open a file to read it, highlighted." },
  { id: "changes", icon: "git-compare", title: "Changes", about: "What your agents changed: every file with its diff, and a commit box." },
];

// The key bound to a command, as people press it: "Ctrl+Shift+P".
function bound(action) {
  const k = keys().find((b) => b.section === "global" && b.action === action);
  return k ? k.keys.split("-").map((p) => (p === "cmd" ? "\u2318" : p.charAt(0).toUpperCase() + p.slice(1))).join("+") : null;
}

function find(node, id) {
  if (!node) return null;
  if (node.id === id) return node;
  for (const c of node.children ?? []) {
    const f = find(c, id);
    if (f) return f;
  }
  return null;
}

export default class Welcome extends View {
  init(_props, cx) {
    this.page = 1;
    this.machines = [];
    this.copied = null;
    this.appearance = null;
    this.handle = cx.focus_handle();
    this.handle.focus();
    // It opens while the window is still starting, which takes the keyboard
    // back for its first pane: take it again once that's done.
    cx.timer.after(600, () => this.handle.focus());
    cx.spawn(async (cx) => {
      try {
        this.appearance = JSON.parse((await readTextFile(`${appHome()}/settings.json`)) ?? "{}").appearance ?? null;
      } catch {}
      await this.loadMachines();
      cx.notify();
    });
    // Machines added meanwhile (the Add a machine dialog) appear.
    cx.timer.every(3000, (cx) => {
      if (this.page !== 2) return;
      cx.spawn(async (cx) => {
        await this.loadMachines();
        cx.notify();
      });
    });
  }

  async loadMachines() {
    const r = await hc(["machine", "ls", "--json"]).catch(() => null);
    try {
      this.machines = r?.code === 0 ? (JSON.parse(r.stdout).machines ?? []).filter((m) => !m.temporary) : [];
    } catch {
      this.machines = [];
    }
  }

  done(outcome) {
    setShared("frame.welcomed", outcome);
    closeOverlay(props().overlay);
  }

  start() {
    this.done("finished");
    if (spaces().length === 0) run("space.new");
  }

  setAppearance(value, cx) {
    this.appearance = value;
    cx.spawn(async (cx) => {
      const file = `${appHome()}/settings.json`;
      for (let i = 0; i < 3; i++) {
        const raw = await readTextFile(file);
        let p = {};
        try {
          p = raw ? JSON.parse(raw) : {};
        } catch {
          return;
        }
        if (value === null) delete p.appearance;
        else p.appearance = value;
        try {
          await writeTextFile(file, JSON.stringify(p, null, 2) + "\n", raw);
          break;
        } catch {}
      }
      cx.notify();
    });
    cx.notify();
  }

  // The panels picked: the tab bar shows a button for each.
  panels() {
    return shared("workspace.panels") ?? PANELS.map((p) => p.id);
  }

  togglePanel(id) {
    const on = this.panels().includes(id);
    const next = on ? this.panels().filter((x) => x !== id) : [...this.panels(), id];
    setShared("workspace.panels", next);
    const L = layout();
    if (!find(L, "panel")) return;
    if (on) {
      if (find(L, "panel-body")?.active === id || next.length === 0) run("layout.hide", { id: "panel" });
    } else {
      run("layout.select", { stack: "panel-body", child: id });
      run("layout.show", { id: "panel" });
    }
  }

  // Pieces -------------------------------------------------------------

  para(t, text) {
    return div().w_full().text_size(13).line_height("20px").text_color(t.muted).child(text);
  }

  title(t, text, sub) {
    return v_flex()
      .gap(6)
      .child(div().text_size(18).font_semibold().text_color(t.foreground).child(text))
      .when(Boolean(sub), (el) => el.child(this.para(t, sub)));
  }

  button(t, id, label, primary, onClick, icon) {
    return h_flex()
      .id(id)
      .h(34)
      .px(14)
      .gap(8)
      .items_center()
      .rounded(9)
      .cursor_pointer()
      .text_size(13)
      .font_medium()
      .when(primary, (el) => el.bg(t.solid).text_color(t.solid_foreground).hover((s) => s.opacity(0.88)))
      .when(!primary, (el) => el.text_color(t.muted).hover((s) => s.text_color(t.foreground).bg(t.hover)))
      .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
      .on_click(onClick)
      .child(label)
      .when(Boolean(icon), (el) => el.child(svg(I(icon)).size(14)));
  }

  segment(t, items, now, onPick) {
    return h_flex()
      .p(2)
      .gap(2)
      .rounded(8)
      .border_1()
      .border_color(t.border)
      .bg(t.chrome)
      .children(
        items.map(([value, label]) =>
          div()
            .id(`w-seg-${label}`)
            .px(11)
            .py(4)
            .rounded(6)
            .text_size(12.5)
            .cursor_pointer()
            .when(now === value, (el) => el.bg(t.popover).text_color(t.foreground).border_1().border_color(t.border).shadow_sm())
            .when(now !== value, (el) => el.text_color(t.muted).hover((s) => s.text_color(t.foreground)))
            .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
            .on_click((_e, cx) => onPick(value, cx))
            .child(label),
        ),
      );
  }

  sizeControl(t) {
    const step = (id, label, cmd) =>
      div()
        .id(id)
        .w(28)
        .h(26)
        .rounded(6)
        .flex()
        .items_center()
        .justify_center()
        .text_size(14)
        .text_color(t.muted)
        .cursor_pointer()
        .hover((s) => s.bg(t.hover).text_color(t.foreground))
        .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
        .on_click(() => run(cmd))
        .child(label);
    return h_flex()
      .p(2)
      .gap(2)
      .items_center()
      .rounded(8)
      .border_1()
      .border_color(t.border)
      .bg(t.chrome)
      .child(step("w-zoom-out", "\u2212", "app.zoom_out"))
      .child(div().w(44).text_size(12.5).text_color(t.foreground).flex().justify_center().child(`${Math.round((settings().zoom ?? 1) * 100)}%`))
      .child(step("w-zoom-in", "+", "app.zoom_in"));
  }

  feature(t, icon, title, body) {
    return h_flex()
      .gap(12)
      .items_start()
      .child(div().flex_none().w(32).h(32).rounded(9).bg(t.raised).border_1().border_color(t.border).flex().items_center().justify_center().child(svg(I(icon)).size(16).text_color(t.accent)))
      .child(v_flex().flex_1().min_w(0).gap(3).child(div().text_size(13.5).font_semibold().text_color(t.foreground).child(title)).child(this.para(t, body)));
  }

  copyLine(t, text, id = "w-copy") {
    const copied = this.copied === id;
    return v_flex()
      .gap(10)
      .p(12)
      .rounded(10)
      .bg(t.background)
      .border_1()
      .border_color(t.input)
      .child(div().text_size(13).line_height("20px").text_color(t.foreground).child(text))
      .child(
        h_flex().child(
          div()
            .id(id)
            .px(12)
            .py(5)
            .rounded(7)
            .cursor_pointer()
            .text_size(12.5)
            .font_medium()
            .bg(copied ? t.ansi2 + "22" : t.raised)
            .text_color(copied ? t.ansi2 : t.foreground)
            .border_1()
            .border_color(t.border)
            .hover((s) => s.bg(t.hover))
            .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
            .on_click((_e, cx) => {
              cx.write_to_clipboard(text);
              this.copied = id;
              cx.notify();
            })
            .child(copied ? "Copied" : "Copy"),
        ),
      );
  }

  comingFromHerdr(t) {
    return v_flex()
      .gap(12)
      .p(16)
      .rounded(12)
      .border_1()
      .border_color(t.border)
      .bg(t.raised)
      .child(
        h_flex()
          .gap(10)
          .items_center()
          .child(svg(I("terminal")).size(16).text_color(t.muted))
          .child(div().text_size(13.5).font_semibold().text_color(t.foreground).child("Coming from herdr?")),
      )
      .child(this.para(t, "This is a new app on a new core. Your herdr workspaces stay where they are; nothing moves over."))
      .child(this.para(t, "Same idea as before: spaces, tabs and terminals."))
      .child(this.para(t, "Want your keybinds and settings carried over? Give your agent this line:"))
      .child(this.copyLine(t, MIGRATE, "w-migrate-copy"));
  }

  // Pages ---------------------------------------------------------------

  pageOne(t) {
    return v_flex()
      .gap(18)
      .child(this.title(t, "Herdr runs your terminals in the background", "The terminals and agents you open here don't live in this window. They run in herdr-core, a small background program on your computer. Close Herdr, update it, or let it crash, and your agents keep working. Open it again and everything is where you left it, as long as the computer is on."))
      .child(this.feature(t, "bot", "Agents tell you when they need you", "A ring while one works, \u201cNeeds you\u201d when it asks something, a sound when it finishes."))
      .child(this.feature(t, "messages", "Agents can start helpers", "They show up under the agent that started them. Click one to watch it."))
      .child(this.feature(t, "layers", "Your other machines, in the same window", "A server or a Mac mini runs its own herdr-core, so its agents keep going even while this laptop sleeps."))
      .child(div().h(1).bg(t.border))
      .child(h_flex().gap(10).items_center().child(div().w(84).text_size(13).text_color(t.muted).child("Appearance")).child(this.segment(t, APPEARANCES, this.appearance, (v, cx) => this.setAppearance(v, cx))))
      .child(h_flex().gap(10).items_center().child(div().w(84).text_size(13).text_color(t.muted).child("Size")).child(this.sizeControl(t)))
      .child(this.comingFromHerdr(t));
  }

  machineRow(t, icon, name, note, ok) {
    return h_flex()
      .h(42)
      .px(12)
      .gap(10)
      .items_center()
      .border_b(1)
      .border_color(t.border)
      .child(svg(W(icon)).size(15).text_color(t.muted))
      .child(div().flex_1().min_w(0).truncate().text_size(13).text_color(t.foreground).child(name))
      .child(div().text_size(12).text_color(t.dim).child(note))
      .child(div().w(8).h(8).rounded(4).bg(ok ? t.ansi2 : t.dim));
  }

  pageTwo(t) {
    return v_flex()
      .gap(18)
      .child(this.title(t, "Add your other machines", "Pick a host from your ssh config. Herdr connects, installs herdr-core there if it's missing, and lists that machine in the sidebar with its own spaces."))
      .child(
        v_flex()
          .rounded(12)
          .border_1()
          .border_color(t.border)
          .bg(t.background)
          .overflow_hidden()
          .child(this.machineRow(t, "monitor", "This computer", "here", true))
          .children(this.machines.map((m) => this.machineRow(t, "server", m.name, m.state === "connected" ? "connected" : (m.state ?? "offline").replace(/_/g, " "), m.state === "connected")))
          .child(
            h_flex()
              .id("w-add-machine")
              .h(42)
              .px(12)
              .gap(10)
              .items_center()
              .cursor_pointer()
              .text_size(13)
              .text_color(t.accent)
              .hover((s) => s.bg(t.hover))
              .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
              .on_click(() => run("mod.open", { name: "machine-add" }))
              .child(svg(W("plus")).size(15))
              .child("Add a machine"),
          ),
      )
      .child(this.para(t, "Not now? Add machine is at the bottom of the sidebar too."));
  }

  panelCard(t, p) {
    const on = this.panels().includes(p.id);
    return h_flex()
      .id(`w-panel-${p.id}`)
      .p(12)
      .gap(12)
      .items_start()
      .rounded(12)
      .border_1()
      .border_color(on ? t.accent : t.input)
      .when(on, (el) => el.bg(t.accent + "10"))
      .cursor_pointer()
      .hover((s) => s.border_color(on ? t.accent : t.ring))
      .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
      .on_click((_e, cx) => {
        this.togglePanel(p.id);
        cx.notify();
      })
      .child(div().flex_none().w(32).h(32).rounded(9).bg(t.raised).border_1().border_color(t.border).flex().items_center().justify_center().child(svg(W(p.icon)).size(16).text_color(t.foreground)))
      .child(
        v_flex()
          .flex_1()
          .min_w(0)
          .gap(4)
          .child(
            h_flex()
              .gap(8)
              .items_center()
              .child(div().text_size(13.5).font_semibold().text_color(t.foreground).child(p.title))
              .child(div().px(6).py(0.5).rounded(5).bg(t.hover).text_size(11).text_color(t.dim).child(`mods/${p.id}`)),
          )
          .child(this.para(t, p.about)),
      )
      .child(
        div()
          .flex_none()
          .mt(4)
          .w(34)
          .h(20)
          .rounded(10)
          .p(2)
          .bg(on ? t.accent : t.input)
          .flex()
          .when(on, (el) => el.justify_end())
          .child(div().w(16).h(16).rounded(8).bg(on ? t.accent_foreground : t.muted)),
      );
  }

  pageThree(t) {
    // The first look at this page asks: nothing is picked yet (skipping the
    // welcome leaves both on).
    if (shared("workspace.panels") === undefined || shared("workspace.panels") === null) setShared("workspace.panels", []);
    return v_flex()
      .gap(14)
      .child(this.title(t, "Choose your panels", "Herdr comes with a couple of panels. Turn one on and it appears beside your terminals. Drag this window aside to see it. Later, the buttons in the tab bar open and close them."))
      .children(PANELS.map((p) => this.panelCard(t, p)))
      .child(
        h_flex()
          .gap(10)
          .items_start()
          .p(12)
          .rounded(10)
          .bg(t.raised)
          .child(this.para(t, "Ask your agent for a board of your agents, your pull requests, a cost meter, or the sidebar on the right. Not sure what's possible? Ask it that too.")),
      );
  }

  pageFour(t) {
    const pal = bound("app.palette");
    return v_flex()
      .gap(16)
      .when(Boolean(pal), (el) =>
        el.child(
          h_flex()
            .gap(12)
            .items_center()
            .p(12)
            .rounded(10)
            .border_1()
            .border_color(t.accent)
            .bg(t.accent + "10")
            .child(div().flex_none().px(8).py(3).rounded(6).border_1().border_color(t.border).bg(t.raised).text_size(13).font_semibold().text_color(t.foreground).child(pal))
            .child(
              v_flex()
                .flex_1()
                .min_w(0)
                .gap(2)
                .child(div().text_size(13.5).font_semibold().text_color(t.foreground).child("One key opens everything"))
                .child(this.para(t, "It opens the command palette, with every action by name and its key. It works the same in every layout.")),
            ),
        ),
      )
      .child(this.title(t, "Make it yours", "Every part of this window is a layout or a mod: plain files your agent can change or add to. Give it this line to start:"))
      .child(this.copyLine(t, ASK))
      .child(this.para(t, "Then ask for anything: \u201cmove the sidebar to the right\u201d, \u201ca panel with my pull requests\u201d."))
      .child(
        v_flex()
          .gap(6)
          .p(12)
          .rounded(10)
          .bg(t.raised)
          .child(div().text_size(13.5).font_semibold().text_color(t.foreground).child("Your terminals, outside this window too"))
          .child(this.para(t, "hc is herdr-core's command line. In any terminal, hc ls lists everything running and hc attach t3 jumps into one. Your agents can use it to start and watch other agents for you. Tell them to read hc's help, or make it a skill.")),
      )
      .child(
        v_flex()
          .gap(10)
          .p(12)
          .rounded(10)
          .bg(t.raised)
          .child(div().text_size(13.5).font_semibold().text_color(t.foreground).child("More examples in Settings"))
          .child(this.para(t, "Settings \u203a Look has more layouts to try or start from, Herdr 98 among them. Your agent can copy any of them and change anything.")),
      )
      .child(this.para(t, "Something off or missing? Settings \u203a Send feedback. We read every one."));
  }

  render() {
    const t = theme();
    const go = (page, cx) => {
      this.page = Math.max(1, Math.min(PAGES, page));
      cx.notify();
    };
    const dots = h_flex()
      .gap(5)
      .children([...Array(PAGES)].map((_, i) => i + 1).map((p) => div().w(p === this.page ? 16 : 6).h(6).rounded(3).bg(p === this.page ? t.foreground : t.input)));
    return v_flex()
      .id("welcome")
      .track_focus(this.handle)
      .size_full()
      .bg(t.popover)
      .on_key_down((e, cx) => {
        const k = e.key;
        const m = e.modifiers;
        if (k === "escape") return this.done("skipped");
        if (m.control || m.alt || m.platform) return;
        if (k === "enter" || k === "right") {
          if (this.page === PAGES) return k === "enter" ? this.start() : undefined;
          go(this.page + 1, cx);
        } else if (k === "left") go(this.page - 1, cx);
        else return;
        cx.stop_propagation();
      })
      .child(
        h_flex()
          .flex_none()
          .h(52)
          // Only the header drags the window, and only it shows the grab hand.
          .cursor_grab()
          .pl(20)
          .pr(12)
          .gap(10)
          .items_center()
          .border_b(1)
          .border_color(t.border)
          .child(image("frame/welcome/herdr.png").w(24).h(24).rounded(6).flex_none())
          .child(div().text_size(14).font_semibold().text_color(t.foreground).child("Welcome to Herdr"))
          .child(div().px(6).py(0.5).rounded(5).border_1().border_color(t.input).text_color(t.muted).text_size(10.5).font_semibold().child("BETA"))
          .child(div().flex_1())
          .child(div().text_size(11.5).text_color(t.dim).child("Drag to move"))
          .child(
            div()
              .id("w-close")
              .w(26)
              .h(26)
              .rounded(7)
              .flex()
              .items_center()
              .justify_center()
              .text_color(t.muted)
              .cursor_pointer()
              .hover((s) => s.bg(t.hover).text_color(t.foreground))
              .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
              .on_click(() => this.done("skipped"))
              .child(svg(W("x")).size(14)),
          ),
      )
      // A bar that always shows: a page taller than the window should look it.
      .child(
        div()
          .relative()
          .flex_1()
          .min_h(0)
          .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
          .child(
            div()
              .id("w-body")
              .size_full()
              .overflow_y_scroll()
              // Padding inside, not on the scroll area: there it counts as
              // content and a page that fits still shows a bar.
              .child(div().px(22).pt(22).pb(20).child([this.pageOne, this.pageTwo, this.pageThree, this.pageFour][this.page - 1].call(this, t))),
          )
          .child(Scrollbar.vertical("w-body").mode("always").absolute().inset_0()),
      )
      .child(
        h_flex()
          .flex_none()
          .px(16)
          .py(12)
          .gap(6)
          .items_center()
          .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
          .border_t(1)
          .border_color(t.border)
          .child(div().pl(6).child(dots))
          .child(div().flex_1())
          .when(this.page > 1, (el) => el.child(this.button(t, "w-back", "Back", false, (_e, cx) => go(this.page - 1, cx))))
          .child(
            this.page < PAGES
              ? this.button(t, "w-next", this.page === 2 && !this.machines.length ? "Not now" : "Next", true, (_e, cx) => go(this.page + 1, cx), "arrow-right")
              : this.button(t, "w-start", spaces().length ? "Done" : "Open a space", true, () => this.start(), "arrow-right"),
          ),
      );
  }
}
