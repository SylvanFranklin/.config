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
```
