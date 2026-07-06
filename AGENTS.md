# AGENTS.md

Orchestration contract for the 5 parallel config agents working in this repo.
Read this before writing anything. Violating scope = task failure.

## Source of truth
- `DESIGN.md` — colors, fonts, radii, spacing. Read-only for all agents.
- `AGENTS.md` (this file) — scope boundaries. Read-only for all agents.
Neither file is ever modified by domain agents.

## Agents and exclusive write scope

| Agent | Owns (read/write) | Never touches |
|---|---|---|
| Agent-Hypr | `hypr/hyprland.lua`, `hypr/keybinds.lua`, `hypr/monitors.lua`, `hypr/autostart.lua`, `hypr/rules.lua`, `hypr/animations.lua` | `hypr/hyprpaper.conf` (owned by Agent-Hyprpaper) |
| Agent-Waybar | `waybar/config.jsonc`, `waybar/style.css` | anything outside `waybar/` |
| Agent-Fuzzel | `fuzzel/fuzzel.ini` | anything outside `fuzzel/` |
| Agent-Hyprpaper | `hypr/hyprpaper.conf`, `scripts/wallpaper.sh` | any other file in `hypr/` |
| Agent-Yazi | `yazi/yazi.toml`, `yazi/theme.toml`, `yazi/keymap.toml` | anything outside `yazi/` |

Coordinator (not a domain agent) owns: `install.sh`, `README.md`, `AGENTS.md`, directory scaffolding, git commits, `gh repo create`.

## Hard rules
1. One agent = one directory. No cross-writes, no "helping" another agent's files.
2. Shared values (accent color, mod key, gaps, font) come only from `DESIGN.md`. Never hardcode a value another domain also needs — reference the same source.
3. No agent runs `git commit` or `git push`. Agents produce files; Coordinator commits.
4. No agent installs packages or edits `install.sh`. Package list changes go through Coordinator.
5. If a required value is missing from `DESIGN.md`, use a clearly marked `TEMPORARY` placeholder and flag it in your output — don't invent final values.
6. Workspaces are capped at 5 (1-5) everywhere. No agent adds workspace 6+.
7. Every non-obvious config line gets a one-line comment.
8. No placeholders/TODOs in delivered configs — they must run as-is.

## Conflict resolution
If two agents' outputs reference the same variable inconsistently, Coordinator wins: Coordinator re-derives the value from `DESIGN.md` and patches both. Domain agents don't negotiate with each other directly.

## Execution order
1. Coordinator scaffolds empty dirs + this file + `DESIGN.md`.
2. 5 domain agents run (parallel or sequential-simulated), each restricted to its table row.
3. Coordinator validates no scope overlap occurred, integrates, commits.
4. Coordinator writes `install.sh` + `README.md`, commits.
5. Coordinator runs `gh repo create dotfiles --public --source=. --remote=origin --push`.
