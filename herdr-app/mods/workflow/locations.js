import { spaces, run } from "herdr";
const normalize = p => (p || "").replace(/\/+$/, "") || "/";
export function goFolder(folder) {
  folder = normalize(folder);
  const existing = spaces().find(s => !s.machine && normalize(s.folder) === folder);
  if (existing) run("space.select", { id: existing.id });
  else run("space.new", { folder });
}
