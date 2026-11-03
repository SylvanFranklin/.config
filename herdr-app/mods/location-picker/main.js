import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { exec, home, spaces, run, theme, props, closeOverlay, shared, setShared } from "herdr";

import { goFolder } from "./locations.js";
export default class LocationPicker extends View {
  init(_props, cx) {
    this.items = [home()]; this.at = 0; this.filter = ""; this.error = "";
    this.input = InputState.new({ placeholder: "Filter folders…" });
    this.input.on("change", (_e, cx) => { this.filter = this.input.value(); this.at = 0; cx.notify(); });
    this.input.on("submit", () => this.choose(this.rows()[this.at]));
    this.input.focus();
    this.handle = cx.focus_handle();
    cx.spawn(async cx => {
      try {
        const h = home();
        const r = await exec("/bin/zsh", ["-lc", 'for d in "$HOME" "$HOME/Documents/projects" "$HOME/Documents" "$HOME/Movies"; do [ -d "$d" ] && find "$d" -mindepth 1 -maxdepth 1 -type d -not -name ".*" -print; done']);
        if (r.code !== 0) this.error = "Some folders could not be listed.";
        this.items = [...new Set([h, ...r.stdout.split("\n").filter(Boolean)])].sort((a,b) => a.localeCompare(b));
      } catch (e) { this.error = String(e); }
      cx.notify();
    });
  }
  rows() {
    const words = this.filter.toLowerCase().split(/\s+/).filter(Boolean);
    return this.items.filter(p => words.every(w => p.toLowerCase().includes(w)));
  }
  choose(path) { if (!path) return; closeOverlay(props().overlay); goFolder(path); }
  render() {
    const t = theme(), rows = this.rows();
    this.at = Math.max(0, Math.min(this.at, rows.length - 1));
    const start = Math.max(0, Math.min(this.at - 5, rows.length - 12));
    return v_flex().id("location-picker").track_focus(this.handle).w_full().p(18).gap(10).bg(t.popover)
      .on_key_down((e,cx) => {
        if (e.key === "escape") { closeOverlay(props().overlay); cx.stop_propagation(); return; }
        if (e.key === "down") this.at = Math.min(rows.length - 1, this.at + 1);
        else if (e.key === "up") this.at = Math.max(0, this.at - 1);
        else return;
        cx.stop_propagation(); cx.notify();
      })
      .child(h_flex().justify_between().child(div().text_size(15).font_semibold().text_color(t.foreground).child("Go to a location")).child(div().text_size(11).text_color(t.dim).child("↑ ↓  Enter  Esc")))
      .child(h_flex().h(36).px(10).items_center().rounded(6).border_1().border_color(t.accent).bg(t.background).child(Input.new(this.input).flex_1().h_full().text_size(13).text_color(t.foreground)))
      .children(rows.slice(start, start + 12).map((p,i) => h_flex().id(`location-${i}`).h(29).px(8).items_center().rounded(4).cursor_pointer().when(start+i === this.at, el => el.bg(t.hover)).hover(el => el.bg(t.hover)).on_click(() => this.choose(p)).child(div().text_size(13).truncate().text_color(t.foreground).child(p === home() ? "~" : p.replace(home() + "/", "~/")))))
      .when(!rows.length, el => el.child(div().text_size(12).text_color(t.dim).child("No matching locations")))
      .when(!!this.error, el => el.child(div().text_size(12).text_color(t.dim).child(this.error)));
  }
}
