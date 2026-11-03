import { View, div } from "gpui-kit";
import { nextCommand, run, home, focused } from "herdr";
import { goFolder } from "./locations.js";
export default class Workflow extends View {
  init(_props, cx) {
    cx.spawn(async cx => { for (;;) {
      const c = await nextCommand();
      const roots = { notes: "/Documents/notes", projects: "/Documents/projects", movies: "/Movies", config: "/.config", home: "", downloads: "/Downloads" };
      if (Object.prototype.hasOwnProperty.call(roots, c)) goFolder(home() + roots[c]);
      else if (c === "yazi") run("tab.new", { name: "yazi", argv: ["yazi"] });
      else if (c === "git") run("tab.new", { name: "git", argv: ["lazygit"] });
      else if (c === "codex") run("tab.new", { argv: ["codex", "--no-alt-screen"] });
      else if (c === "scripts") run("tab.new", { name: "scripts", argv: ["bash", home() + "/.config/scripts/script-picker.sh", focused()?.cwd || home()] });
      else if (c === "typst") run("tab.new", { name: "typst", argv: ["bash", home() + "/.config/scripts/typst-preview-picker.sh", focused()?.cwd || home()] });
      else if (c === "links") run("tab.new", { argv: ["bash", home() + "/.config/scripts/links-picker.sh"] });
      else if (c === "pdf") run("tab.new", { name: "pdf", argv: ["bash", home() + "/.config/scripts/open-pdf.sh"] });
      cx.notify();
    }});
  }
  render() { return div().h(1); }
}
