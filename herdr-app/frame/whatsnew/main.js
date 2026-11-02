// One window for this launch's unpresented spotlights. The app supplies the
// release range; only entries shown in full here count as presented.
import { View, div, svg, image } from "gpui-kit";
import { v_flex, h_flex, Scrollbar } from "gpui-base";
import { theme, props, closeOverlay, presentUpdateNotes, updates } from "herdr";
import { versionHeader, releaseItems } from "./release-notes.js";

export default class WhatsNew extends View {
  init(_props, cx) {
    this.notes = props()?.notes ?? [];
    presentUpdateNotes(this.notes.filter(n => n.spotlight).map(n => n.version));
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(600, () => this.handle.focus());
  }

  done() {
    closeOverlay(props().overlay);
  }

  releaseNotes(t) {
    const body = v_flex().gap(18);
    for (const note of this.notes) {
      const current = updates().notes?.find(n => n.version === note.version) ?? note;
      const entry = v_flex().gap(16)
        .child(versionHeader(t, note))
        .child(releaseItems(t, current, { width: this.notesWidth, onSizeChange: (size, cx) => { this.notesWidth = size.width; cx.notify(); } }));
      body.child(entry);
    }
    return body;
  }

  render() {
    const t = theme();
    return v_flex()
      .id("whatsnew").track_focus(this.handle).size_full().bg(t.popover)
      .on_key_down((e, cx) => {
        if (e.key === "escape" || e.key === "enter") {
          this.done();
          cx.stop_propagation();
        }
      })
      .child(h_flex().flex_none().h(52).cursor_grab().pl(20).pr(12).gap(10).items_center().border_b(1).border_color(t.border)
        .child(image("frame/welcome/herdr.png").w(24).h(24).rounded(6).flex_none())
        .child(div().text_size(14).font_semibold().text_color(t.foreground).child("What's new in Herdr"))
        .child(div().flex_1())
        .child(div().id("wn-close").size(26).rounded(7).flex().items_center().justify_center()
          .text_color(t.muted).cursor_pointer().hover(s => s.bg(t.hover).text_color(t.foreground))
          .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
          .on_click(() => this.done()).child(svg("mods/workspace-chrome/x.svg").size(14))))
      .child(div().relative().flex_1().min_h(0)
        .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
        .child(div().id("wn-body").size_full().overflow_y_scroll()
          .child(div().px(22).pt(20).pb(20).child(this.releaseNotes(t))))
        .child(Scrollbar.vertical("wn-body").mode("always").absolute().inset_0()))
      .child(h_flex().flex_none().px(16).py(12).gap(8).items_center().border_t(1).border_color(t.border)
        .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
        .child(div().pl(6).flex_1().text_size(12).text_color(t.dim).child("Something off or missing? Settings › Send feedback."))
        .child(h_flex().id("wn-done").h(30).px(12).items_center().rounded(8).cursor_pointer()
          .text_size(12.5).font_medium().bg(t.solid).text_color(t.solid_foreground).hover(s => s.opacity(0.88))
          .on_click(() => this.done()).child("Got it")));
  }
}
