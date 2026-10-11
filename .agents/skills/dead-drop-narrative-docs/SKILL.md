---
name: dead-drop-narrative-docs
description: Use when creating or editing DEAD DROP story/character docs under docs/, or when the user states any new lore fact about characters, plot, places, tone, or canon — even casually, without asking to update files.
---

# DEAD DROP Narrative Docs

## Overview

Narrative source of truth lives in **English markdown** under `docs/`.  
Protect structure and indexes. Prefer surgical edits. Never invent facts the user did not give.

**Core principles:**
1. One canonical sheet per entity; indexes stay accurate.
2. **All narrative docs are living documents** — always subject to change.
3. **User-stated lore must be filed** into the right doc(s), even if they never say “update the docs.”
4. Gameplay text consumes docs; it is not a second silent canon.

## Living documents (everything can change)

Nothing in `docs/` is frozen against the **user**.

| Who | May change docs? |
|-----|------------------|
| **User** (any clear statement of fact or revision) | Yes — always. File it. |
| **Agent** inventing flavor “to flesh things out” | **No.** |
| **Agent** matching prototype levels by rewriting high-priority sheets | **No**, unless user wants that. |

Labels like *Final canon* / *Provisional canon* mean “treat as true for design **until the user changes it**,” not “never edit this file.”

When the user changes a fact:

- Update every affected file (character sheet, overview, timeline, relationships, etc.).
- Prefer **replace** the old fact in place when it is a simple correction.
- Use **(Superseded)** only when keeping the old wording is useful for history, or when the change is controversial/partial and needs a breadcrumb.
- Remove the fact from **Open questions** if it was listed as TBD.
- Do not demand a formal “canon revision” ceremony. A casual line is enough.

**Example:** User says “a Nico le gusta tocar la guitarra” while talking about something else → still update `docs/characters/nicolas-ferreyra.md` (personality/habits or open-questions resolution) in that turn or immediately after the substantive reply. Do not wait for “ponelo en el doc.”

## Proactive canon capture

**Trigger:** the user asserts something about the world or cast (taste, job detail, relationship, location name, timeline beat, tone rule, constraint).

**Required response pattern:**

```text
1. Notice the fact (even if buried in chat about code/design)
2. Classify: character | story | location | timeline | multi
3. Edit the canonical file(s) — English, correct section
4. Fix indexes/cross-links if needed
5. Briefly tell the user what you filed (one line is enough)
```

Do **not**:

- Only acknowledge in chat and leave docs stale
- Ask “¿querés que lo anote?” when the fact is clear — just note it
- Invent extra details around the new fact
- Skip filing because the user “didn’t ask for documentation”

Still **ask** when the statement is ambiguous (which character? joke vs canon? contradicts a core trait without saying it replaces it?).

### Soft vs hard contradiction

| User intent | Agent action |
|-------------|--------------|
| Additive (“also likes guitar”) | Add surgically |
| Replacement (“actually he’s 31”) | Replace old value; drop from TBD |
| Unclear conflict with core sheet | Ask one short question, then file |
| Explicit “ignore the docs for now” | Obey for the task; do not delete canon |

## When to Use

- Creating/editing/reorganizing anything under `docs/story` or `docs/characters`
- User pastes lore (any language) to file
- User casually states a new canon fact mid-conversation
- In-game / terminal text that encodes story beats
- Risk of contradicting existing narrative docs

**When NOT to use:** pure engine work with zero lore; unrelated chit-chat with no world facts.

## Layout (do not relocate without explicit user approval)

```
docs/
  story/
    README.md
    overview.md
    timeline.md
    locations.md
  characters/
    README.md
    _template.md
    <slug>.md
    player.md          # pointer to protagonist only
```

| Path | Owns |
|------|------|
| `docs/characters/<slug>.md` | Who someone is |
| `docs/story/*` | What happens / where / when |
| `data/terminal_message.txt` | Playable dump only — must not silently redefine canon |

Skill path: `.agents/skills/dead-drop-narrative-docs/`.

## Language

- **All narrative docs: English.**
- User lore in Spanish (or other) → **translate when filing**, unless they demand the source language kept.
- Code and terminal dumps stay as designed.

## Canon status vocabulary

| Label | Meaning |
|-------|---------|
| **Final canon** | Authoritative for design **until the user changes it** |
| **Provisional canon** | True for now; expected to evolve |
| **Prototype fiction** | Playable build only; may not match docs |
| **Open / TBD** | Unknown — **agent must not invent**; **user may fill anytime** (then file and clear TBD) |
| **Superseded** | Kept for history; not current truth |

Priority banners (e.g. High on the protagonist) mean “edit carefully and keep structure,” not “refuse updates.”

## Character files

### Create

1. Copy `docs/characters/_template.md` → `docs/characters/<slug>.md`.
2. `slug` = lowercase ASCII hyphens (`nicolas-ferreyra`).
3. Fill what the user gave; leave the rest `*(TBD)*`.
4. Add a row to `docs/characters/README.md`.
5. Protagonist: `player.md` stays a **pointer only**.
6. Link from story docs when the plot depends on them.

### Full vs short sheets

- **Major cast / protagonist:** keep deep numbered structure when already established (`nicolas-ferreyra.md`).
- **Minor NPCs:** short template sections.

Do not strip a major sheet without approval. Do not bloat every NPC into an epic.

### Edit (safe)

1. Read the full file first.
2. Touch the minimum sections needed for the new fact(s).
3. Preserve headings, numbering, rules, tables unless restructuring was requested.
4. Hard contradictions: ask if unclear; otherwise replace or mark superseded per table above.
5. Update README / links if name, slug, or role changes.
6. Skim for internal consistency after edits.

### Where small facts go (examples)

| Fact type | Typical home |
|-----------|----------------|
| Hobby, habit, taste | Personality, Background, or a short “Habits” bullet under Identity/Personality |
| Exact age, job title | Identity table |
| Friend detail | Relationships + later that friend’s own sheet |
| Skill limit / strength | Profession and skills |
| Arc / theme change | Character arc + maybe `story/overview.md` |

### Forbidden

- Second conflicting bio for the same person
- Inventing cast, employers, trauma, or TBD answers
- Deleting files instead of superseded status
- Long plot only inside a character file (plot → `docs/story/`)
- Chat-only canon that never hits disk

## Story files

### overview.md

Logline, tone, established facts, open questions, key character links.

### timeline.md

**In-world** + **Playable beats shipped**. Tables: When | Event | Source.

### locations.md

Per place; **Status:** shipped / planned / cut.

### New story files

Under `docs/story/`, `kebab-case.md`, register in `docs/story/README.md`.

### Edit (safe)

Surgical; keep timeline ≠ overview. On real lore change that affects the prototype, update story docs and note implementation sync.

## Cross-linking

- Relative links between characters and story.
- Indexes list every active file.
- `player.md` → one link to protagonist sheet.
- No orphans.

## Implementation sync

Docs are not auto-loaded by Godot.

| Doc fact | May need |
|----------|----------|
| Terminal / NOTE | `data/terminal_message.txt` |
| Player identity on HUD | future UI strings |
| Place exists | scenes / room scripts |

Implementation notes = what the **build** shows. If build ≠ doc, tag prototype fiction; do not bend high-priority canon to a placeholder unless the user says so.

When the user changes canon that the build already shows, either update the build in the same effort or explicitly list it as follow-up — do not leave silent drift after a deliberate canon edit the user asked to play.

## Intake workflow (paste or casual fact)

```text
1. Classify: character | story | location | timeline | mixed
2. Translate to English if needed
3. Map to existing files (edit > create)
4. Structure + TBD for real gaps only
5. Indexes + cross-links
6. Contradictions: fix if clear user intent; else ask
7. Confirm what changed (brief)
```

## Conflict resolution order

1. **Latest clear user statement** (this conversation)
2. High-priority character/story canon sheets (current text)
3. Other `docs/story/` facts
4. Playable prototype strings (truth for “what runs”; weakest for lore)

User always wins over old docs. Old docs win over agent invention. Prototype wins over nothing for runtime, not over user lore.

## Red flags — STOP

- Leaving user-stated lore only in chat
- Asking permission to file a clear fact
- Rewriting a whole sheet for one bullet
- Moving folder layout without approval
- Spanish-only canon files by default
- Duplicating Nico into `player.md` / overview body
- Inventing TBD fills
- Quietly deleting outdated sections
- Treating docs as immutable because they say “Final canon”
- Skipping this skill when lore appeared

## Quick checklist

- [ ] Fact filed to disk (if user stated one)
- [ ] Right folder; English
- [ ] Structure preserved
- [ ] No invented TBDs
- [ ] Indexes / links OK
- [ ] Contradictions handled (replace / supersede / ask)
- [ ] Implementation follow-up noted if build-facing
- [ ] User told what was updated (brief)

## Reference

- `docs/characters/_template.md`
- `docs/characters/nicolas-ferreyra.md`
- `docs/story/README.md`
- `AGENTS.md`
