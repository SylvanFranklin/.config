import { div, image } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { settings } from "herdr";

export function versionHeader(t, note) {
  const [year, month, day] = note.date.split("-");
  const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  const date = year && months[Number(month) - 1] && Number(day)
    ? `${months[Number(month) - 1]} ${Number(day)}` : note.date;
  return h_flex().gap(10).items_center()
    .child(div().text_size(13).font_medium().text_color(t.muted).child(note.version))
    .child(div().text_size(12).text_color(t.dim).child(date));
}

export function releaseItems(t, note, { collapsed = false, width = 0, onSizeChange } = {}) {
  const body = v_flex().id(`release-items-${note.version}`).gap(collapsed ? 8 : 16);
  if (onSizeChange && !collapsed) body.on_size_change(onSizeChange);
  const mediaWidth = width / settings().zoom;
  const highlights = note.items.filter(item => !item.fixed);
  for (const item of highlights) {
    const card = v_flex().w_full().rounded(10).border_1().border_color(t.border).overflow_hidden();
    if (!collapsed) for (const media of item.media) {
      card.child(image(media.path).w_full().h(Math.max(1, mediaWidth - 2) * media.height / media.width).flex_none());
    }
    const text = v_flex().p(collapsed ? 10 : 14).gap(5);
    if (item.headline) text.child(div().text_size(collapsed ? 12 : 14).font_semibold().text_color(t.foreground).child(item.headline));
    if (item.detail && (!collapsed || !item.headline)) text.child(div().text_size(collapsed ? 12 : 13).line_height("20px").text_color(t.muted).child(item.detail));
    body.child(card.child(text));
  }
  const fixes = note.items.filter(item => item.fixed);
  if (fixes.length && !collapsed) {
    const list = v_flex().gap(5)
      .child(div().mb(3).text_size(11).font_medium().text_color(t.dim).child("Also fixed"));
    for (const item of fixes) {
      list.child(div().text_size(12).line_height("17px").text_color(t.muted).child(`• ${[item.headline, item.detail].filter(Boolean).join(" ")}`));
      for (const media of item.media) list.child(image(media.path).w_full().h(Math.max(1, mediaWidth) * media.height / media.width));
    }
    body.child(list);
  }
  return body;
}
