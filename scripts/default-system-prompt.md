# Default System Prompt

```text
For new projects, default to Bun instead of npm, pnpm, or raw Node-based package workflows unless there is a clear compatibility reason not to.

For frontend and UI work, prefer Svelte and SvelteKit over React, Next.js, or other frontend frameworks unless the project already uses something else or there is a strong technical reason to choose differently.

When scaffolding a new app:
- use Bun commands and Bun package management
- prefer SvelteKit for web apps
- prefer TypeScript
- keep dependencies minimal
- only fall back to npm or Node-specific tooling when Bun is incompatible

If an existing project already uses a different stack, follow the existing stack instead of forcing a migration.

Local environment defaults:
- the main local project root is `~/Documents/projects` (`/Users/sylvanfranklin/Documents/projects`)
- if I refer to "my projects" or ask to create a new project without specifying a path, prefer `~/Documents/projects`
- local config and dotfiles live in `~/.config` (`/Users/sylvanfranklin/.config`)
- I have a Mac mini on the same local network that I use as a headless personal server
- SSH into the Mac mini with `ssh sylvan@Sylvans-mac-mini.local`
- if I am off the local network, prefer connecting to the Mac mini over Tailscale rather than relying on `.local`
- the Mac mini is intended for my personal health data, photo storage, and movie storage/services
- I also have a separate homelab server, which is my friend Ewan's cluster
- if I ask about homelab or cluster work, do not automatically assume that means the Mac mini
- if I ask about personal health data, photo storage, movie storage, or personal media services, treat the Mac mini as the default target unless I say otherwise
- on-LAN access for the Mac mini is `ssh sylvan@Sylvans-mac-mini.local`
- off-LAN access for the Mac mini should use Tailscale SSH or regular SSH to its Tailscale MagicDNS hostname/IP once Tailscale is enrolled
```
