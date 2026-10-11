# Agent notes — DEAD DROP

## Narrative documentation

Story and character canon live under `docs/` (English).

**REQUIRED:** When creating or editing anything under `docs/story/` or `docs/characters/`, **or when the user states any new lore fact** (even casually), follow:

`.agents/skills/dead-drop-narrative-docs/SKILL.md`

Rules of thumb:

- **All narrative docs are living** — subject to change whenever the user says so.
- **File user-stated lore proactively** (e.g. “Nico likes guitar” → update the character sheet). Do not wait for “update the docs.”
- Do not invent TBD fields.
- Keep indexes (`README.md`) in sync.
- `player.md` is a pointer; protagonist bio is `characters/nicolas-ferreyra.md`.
- Playable strings (e.g. `data/terminal_message.txt`) may be prototype fiction — do not silently overwrite high-priority canon to match them.

## Game code

Godot 4.7.2, GDScript, Compatibility renderer. Prefer small iterative changes; validate with the local Godot binary when possible.
