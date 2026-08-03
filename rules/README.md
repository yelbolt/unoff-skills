# Unoff Rules

The project rules an AI assistant reads before writing code, in a **neutral
format**. `@unoff/cli` renders this into the file each assistant expects.

Previously every plugin template shipped four hand-maintained copies of these
rules — `CLAUDE.md`, `.github/copilot-instructions.md`, `.cursor/rules/*.mdc`,
`.windsurf/rules/*.md`. They drifted: a diff between the Claude and Copilot
versions ran to 368 lines of the same intent, worded differently. One source,
rendered per target, removes that class of bug.

## Placeholders

Rendered with Mustache by `unoff ai` / `unoff create`:

| Variable            | Example                                |
| ------------------- | -------------------------------------- |
| `{{pluginName}}`    | `My Awesome Plugin`                    |
| `{{platform}}`      | `Figma` / `Penpot`                     |
| `{{platformSlug}}`  | `figma` / `penpot`                     |
| `{{skillsPath}}`    | `.claude/skills/unoff-create-plugin`   |
| `{{specsDir}}`      | `specs`                                |

Platform-specific passages use the `{{#figma}}` / `{{#penpot}}` sections. Keep
them narrow — everything outside them must hold for both platforms.

## Emitted formats

| Target          | Path                              | Wrapper                                    |
| --------------- | --------------------------------- | ------------------------------------------ |
| Claude Code     | `CLAUDE.md`                       | none                                       |
| ChatGPT / Codex | `AGENTS.md`                       | none                                       |
| GitHub Copilot  | `.github/copilot-instructions.md` | none                                       |
| Cursor          | `.cursor/rules/project.mdc`       | `description`, `globs`, `alwaysApply`      |
| Windsurf        | `.windsurf/rules/project.md`      | `trigger`, `description`                   |

Only the frontmatter differs — the body is identical everywhere, which is the
point.

## Editing

Change `plugin.md`, then re-render in a project:

```bash
unoff ai        # or: unoff add rules
```
